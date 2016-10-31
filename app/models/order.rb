class Order < ApplicationRecord
  include MoneyUtilities

  DEFAULT_ORDER_HEADER = [
    "No.", "Activity", "Reservable", "Time",
    "Date", "Number of people","Total Price"
  ]

  has_many :bookings, inverse_of: :order
  belongs_to :user
  belongs_to :activity
  accepts_nested_attributes_for :bookings

  scope :reservations, -> { includes(:activity, :bookings) }
  scope :reservations_on, -> (date) {
    reservations.where(bookings: { booking_date: date }) }
  scope :filterd_by_activity, -> (id) { where(activity_id: id) }
  scope :filterd_by_user, -> (id) { where(user_id: id) }

  delegate :name, to: :activity, prefix: true

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

  def self.game_period(start_time, end_time)
    "#{start_time.strftime("%I:%M %p")} - #{end_time.strftime("%I:%M %p")}"
  end

  def self.booking_date(date)
    date.strftime("%A, %B %e")
  end
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << DEFAULT_ORDER_HEADER

      all.each_with_index do |order, order_index|
        order.bookings.each_with_index do |booking, booking_index|
          row = []

          index = booking_index == 0 ? order_index + 1 : ""
          activity = booking_index == 0 ? order.activity_name : ""
          total_price = booking_index == 0 ? "$ #{order.total_price}" : ""

          row << index
          row << activity
          row << booking.reservable_name
          row << game_period(booking.start_time, booking.end_time)
          row << booking_date(booking.booking_date)
          row << booking.number_of_players
          row << total_price
          csv << row
        end
      end
    end
  end
end
