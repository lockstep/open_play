class Booking < ApplicationRecord
  include DateTimeUtilities

  belongs_to :order, inverse_of: :bookings
  belongs_to :reservable
  belongs_to :parent, class_name: 'Booking', optional: true
  has_one :user, through: :order
  has_many :reservable_options,
           class_name: 'BookingReservableOption',
           inverse_of: :booking
  has_many :children, class_name: 'Booking', foreign_key: 'parent_id'

  validates_presence_of :order, :number_of_players
  validates_numericality_of :number_of_players,
                            only_integer: true,
                            greater_than: 0,
                            if: proc { |object| object.errors.empty? }
  validate :number_of_players_cannot_exceed_maximum, on: :create
  validates_uniqueness_of :reservable_id,
    scope: %i[booking_date start_time end_time parent_id],
    unless: proc { reservable_activity.allow_multi_party_bookings }

  accepts_nested_attributes_for :reservable_options

  delegate :activity,
           :activity_name,
           :name,
           :number_of_booked_players,
           :available_players,
           :options_available,
           :party_room?,
           :allocate_reservables,
           to: :reservable, prefix: true
  delegate :weekday_price,
           :weekend_price,
           :maximum_players,
           :per_person_weekday_price,
           :per_person_weekend_price,
           to: :reservable
  delegate :id, to: :user, prefix: true, allow_nil: true
  delegate :id, to: :order, prefix: true, allow_nil: true
  delegate :reserver_full_name, to: :order, prefix: true

  monetize :booking_price_cents

  scope :during, -> (start_time, end_time, date) {
    where(start_time: start_time, end_time: end_time, booking_date: date)
  }
  scope :find_by_order_ids, -> (order_ids, date) {
    where(order_id: order_ids, booking_date: date)
  }
  scope :filtered_by_reservable_ids, -> (ids) {
    where(reservable_id: ids)
  }
  scope :past_60_days, -> { where('created_at >= ?', 60.days.ago) }
  scope :active, -> { where(canceled: false) }

  def self.belongs_to_business(business_id)
    activity_ids = Business.find(business_id).activities.pluck(:id)
    reservable_ids = Reservable.where(activity_id: activity_ids).pluck(:id)
    filtered_by_reservable_ids(reservable_ids)
      .sorted_by_booking_time
        .order(:order_id)
  end

  def self.belongs_to_activity(activity)
    reservable_ids = activity.reservables.ids
    filtered_by_reservable_ids(reservable_ids)
  end

  def self.sorted_by_booking_time
    order(:booking_date, :start_time, :end_time)
  end

  def self.revenues_by_date_in_60_days
    group(:booking_date).past_60_days.active.order(:booking_date)
      .sum(:booking_price_cents)
  end

  def self.valuable_bookings(order_id)
    where('order_id = ?', order_id)
      .order(:start_time)
      .reject { |booking| booking.children.count.positive? }
  end

  def number_of_players_cannot_exceed_maximum
    if errors.empty? && number_of_players >
      reservable.available_players(start_time, end_time, booking_date)
      errors.add(:number_of_players, 'must be fewer than available players')
    end
  end

  def number_of_time_slots
    minutes_diff = time_diff_in_minutes(start_time, end_time)
    minutes_diff / reservable.interval
  end

  def base_booking_price
    return overridden_price.price if overridden_price?
    weekend_booking? ? weekend_price : weekday_price
  end

  def per_person_price
    return overridden_price.per_person_price if overridden_price?
    weekend_booking? ? per_person_weekend_price : per_person_weekday_price
  end

  def total_base_booking_price
    number_of_time_slots * base_booking_price
  end

  def total_per_person_price
    number_of_time_slots * per_person_price
  end

  def calculate_booking_price
    number_of_time_slots * (base_booking_price + (number_of_players * per_person_price))
  end

  def set_booking_price
    self.booking_price = calculate_booking_price
  end

  def set_paid_externally
    self.paid_externally = true
  end

  def effective_price
    return Money.new(0, 'USD') if canceled
    booking_price
  end

  private

  def weekend_booking?
    booking_date.friday? || booking_date.saturday? || booking_date.sunday?
  end

  def overridden_price
    @rate_override_schedule ||= reservable.rate_override_schedule(
      booking_date.to_s, start_time.to_s)
  end

  def overridden_price?
    overridden_price.present?
  end
end
