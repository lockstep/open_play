class Order < ApplicationRecord
  include ConfirmationOrderConcerns

  has_many :bookings, inverse_of: :order
  belongs_to :user, optional: true
  belongs_to :guest, optional: true
  belongs_to :activity
  accepts_nested_attributes_for :bookings

  scope :filtered_by_activity, -> (id) { where(activity_id: id) }
  scope :filtered_by_user, -> (id) { where(user_id: id) }

  delegate :name, :type, :description, :picture, :business_id, to: :activity,
           prefix: true
  delegate :full_name, to: :user, prefix: true
  delegate :full_name, to: :guest, prefix: true
  delegate :reservable_type, to: :activity

  monetize :price_cents
  monetize :stripe_fee_cents
  monetize :open_play_fee_cents

  ORDER_FEE = 1 # $ unit

  scope :of_businesses, -> (business_ids) {
    select('orders.*')
    .select('businesses.id as business_id')
    .joins(bookings: [reservable: [activity: :business]])
    .where('businesses.id': business_ids)
  }

  scope :claimable_during, -> (from_date, to_date) {
    joins(:bookings)
    .where("booking_date >= ?", from_date)
    .where("booking_date <= ?", to_date)
    .distinct
  }

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
    made_by_business_owner? ? 0 : sub_total_price + ORDER_FEE
  end

  def sub_total_price
    made_by_business_owner? ? 0 : bookings.map(&:booking_price).sum
  end

  def total_valid_price
    bookings.map(&:effective_price).sum + ORDER_FEE
  end

  def self.reservations_for_business_owner(date, activity_id)
    order_ids = filtered_by_activity(activity_id).pluck(:id)
    Booking.find_by_order_ids(order_ids, date)
      .sorted_by_booking_time
        .order(:order_id)
  end

  def self.reservations_for_users(date, user_id)
    order_ids = filtered_by_user(user_id).pluck(:id)
    Booking.find_by_order_ids(order_ids, date)
      .sorted_by_booking_time
        .order(:order_id)
  end

  def made_by_business_owner?
    !guest_order? && user == activity.user
  end

  def set_price_of_bookings
    bookings.each do |booking|
      if made_by_business_owner?
        booking.set_paid_externally
      else
        booking.set_booking_price
      end
    end
  end

  def calculate_cost(current_user)
    return 0 if current_user && current_user ==  activity.user
    set_price_of_bookings
    total_price * 100
  end
end
