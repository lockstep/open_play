class Order < ApplicationRecord
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
end
