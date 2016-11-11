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
  validate :number_of_players_cannot_exceed_maximum

  delegate :activity_name, to: :reservable, prefix: true
  delegate :name, to: :reservable, prefix: true
  delegate :maximum_players, to: :reservable
  delegate :number_of_booked_players, to: :reservable, prefix: true
  delegate :options_available, to: :reservable, prefix: true
  delegate :weekday_price, to: :reservable
  delegate :weekend_price, to: :reservable
  delegate :id, to: :user, prefix: true, allow_nil: true
  delegate :per_person_weekday_price, to: :reservable
  delegate :per_person_weekend_price, to: :reservable
  delegate :activity, to: :reservable, prefix: true
  delegate :id, to: :order, prefix: true
  delegate :reserver_full_name, to: :order, prefix: true

  scope :during, -> (start_time, end_time, date) {
    where(start_time: start_time, end_time: end_time, booking_date: date)
  }
  scope :find_by_order_ids, -> (order_ids, date) {
    where(order_id: order_ids, booking_date: date).order(:start_time)
  }

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

  def booking_price
    base_booking_price + (number_of_players * per_person_price)
  end

  private

  def weekend_booking?
    booking_date.saturday? || booking_date.sunday?
  end
end
