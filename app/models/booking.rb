class Booking < ApplicationRecord
  belongs_to :order, inverse_of: :bookings
  has_one :user, through: :order
  belongs_to :reservable
  has_many :reservable_options, class_name: 'BookingReservableOption',
    inverse_of: :booking
  accepts_nested_attributes_for :reservable_options

  validates_presence_of :order, :number_of_players
  validates_numericality_of :number_of_players, only_integer: true,
    greater_than: 0, if: Proc.new{ |object| object.errors.empty? }
  validate :number_of_players_cannot_exceed_maximum, on: :create

  delegate :activity_name, to: :reservable, prefix: true
  delegate :name, to: :reservable, prefix: true
  delegate :number_of_booked_players, to: :reservable, prefix: true
  delegate :options_available, to: :reservable, prefix: true
  delegate :weekday_price,
    :weekend_price,
    :maximum_players,
    :per_person_weekday_price,
    :per_person_weekend_price, to: :reservable
  delegate :id, to: :user, prefix: true, allow_nil: true
  delegate :activity, to: :reservable, prefix: true
  delegate :id, to: :order, prefix: true, allow_nil: true
  delegate :reserver_full_name, to: :order, prefix: true

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
    reservable_ids = Reservable.filtered_by_activity_ids(activity_ids).pluck(:id)
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
      .sum(:booking_price)
  end

  def number_of_players_cannot_exceed_maximum
    if errors.empty? && number_of_players >
      reservable.available_players(start_time, end_time, booking_date)
      errors.add(:number_of_players, 'must be fewer than available players')
    end
  end

  def base_booking_price
    weekend_booking? ? weekend_price : weekday_price
  end

  def per_person_price
    weekend_booking? ? per_person_weekend_price : per_person_weekday_price
  end

  def calculate_booking_price
    base_booking_price + (number_of_players * per_person_price)
  end

  def set_booking_price
    self.booking_price = calculate_booking_price
  end

  def set_paid_externally
    self.paid_externally = true
  end

  private

  def weekend_booking?
    booking_date.friday? || booking_date.saturday? || booking_date.sunday?
  end
end
