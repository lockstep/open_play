class Order < ApplicationRecord
  include MoneyUtilities

  has_many :bookings, inverse_of: :order
  belongs_to :user
  accepts_nested_attributes_for :bookings

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
    total_price = bookings
      .map { |booking| booking.number_of_players * booking.booking_price }
      .reduce(0, :+)
    dollars_to_cents(total_price)
  end
end
