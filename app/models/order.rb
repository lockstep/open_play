class Order < ApplicationRecord
  include MoneyUtilities

  has_many :bookings, inverse_of: :order
  belongs_to :user, optional: true
  belongs_to :guest, optional: true
  belongs_to :activity
  accepts_nested_attributes_for :bookings

  scope :filtered_by_activity, -> (id) { where(activity_id: id) }
  scope :filtered_by_user, -> (id) { where(user_id: id) }

  delegate :name, to: :activity, prefix: true
  delegate :full_name, to: :user, prefix: true
  delegate :full_name, to: :guest, prefix: true
  delegate :reservable_type, to: :activity

  def booking
    bookings.first
  end

  def booking_date
    booking.booking_date
  end

  def reserver_full_name
    guest_order? ? guest_full_name : user_full_name
  end

  def guest_order?
    guest_id.present?
  end

  def reserver
    guest_order? ? guest : user
  end

  def booking_place
    booking.reservable_activity_name
  end

  def total_price
    bookings.map(&:booking_price).reduce(0, :+)
  end

  def total_price_in_cents
    dollars_to_cents(total_price)
  end

  def self.reservations_for_business_owner(date, activity_id)
    order_ids = filtered_by_activity(activity_id).pluck(:id)
    Booking.find_by_order_ids(order_ids, date)
  end

  def self.reservations_for_users(date, user_id)
    order_ids = filtered_by_user(user_id).pluck(:id)
    Booking.find_by_order_ids(order_ids, date)
  end

  def set_bookings_total_price
    bookings.each { |booking| booking.set_total_price }
  end
end
