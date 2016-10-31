class Order < ApplicationRecord
  include MoneyUtilities

  has_many :bookings, inverse_of: :order
  belongs_to :user
  belongs_to :activity
  accepts_nested_attributes_for :bookings

  scope :reservations, -> { includes(:activity, :bookings) }
  scope :reservations_on, -> (date) {
    reservations.where(bookings: { booking_date: date }) }
  scope :filterd_by_activity, -> (id) { where(activity_id: id) }
  scope :filterd_by_user, -> (id) { where(user_id: id) }

  def booking
    bookings.first
  end

  def booking_date
    booking.booking_date
  end

  def booking_place
    booking.reservable_activity_name
  end

  def total_price
    bookings.map do |booking|
      persons_price = booking.number_of_players * booking.per_person_price
      persons_price + booking.base_booking_price
    end.reduce(0, :+)
  end

  def total_price_in_cents
    dollars_to_cents(total_price)
  end

  def self.reservations_for_business_owner(date, activity_id)
    reservations_on(date).filterd_by_activity(activity_id)
  end

  def self.reservations_for_users(date, user_id)
    reservations_on(date).filterd_by_user(user_id)
  end
end
