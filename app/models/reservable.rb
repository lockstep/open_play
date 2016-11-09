class Reservable < ApplicationRecord
  belongs_to :activity
  has_many :options,
    foreign_key: 'reservable_type',
    primary_key: 'type',
    class_name: 'ReservableOption'
  has_many :options_available, class_name: 'ReservableOptionsAvailable'
  accepts_nested_attributes_for :options_available

  has_many :bookings
  validates_presence_of :name
  validates :interval, numericality: { only_integer: true }
  validates :maximum_players, numericality: { only_integer: true, greater_than: 0 }
  validates :weekday_price, numericality: { greater_than_or_equal_to: 0 }
  validates :weekend_price, numericality: { greater_than_or_equal_to: 0 }
  validates :per_person_weekday_price, numericality: { greater_than_or_equal_to: 0 }
  validates :per_person_weekend_price, numericality: { greater_than_or_equal_to: 0 }
  validate :end_time_is_after_start_time

  delegate :name, to: :activity, prefix: true
  delegate :allow_multi_party_bookings, to: :activity
  delegate :user, to: :activity
  scope :active, -> { where(archived: false) }

  def end_time_is_after_start_time
    return unless start_time.present? && end_time.present?
    return unless start_time > end_time

    errors.add(:end_time, 'must be after the start time')
  end

  def number_of_booked_players(start_time, end_time, date)
    bookings
      .during(start_time, end_time, date)
      .sum("number_of_players")
  end

  def available_players(start_time, end_time, date)
    maximum_players - number_of_booked_players(start_time, end_time, date)
  end

  def opens_24_hours?
    start_time == end_time
  end

  def opening_time
    return start_time unless opens_24_hours?
    Time.parse('00:00')
  end

  def closing_time
    return end_time unless opens_24_hours?
    Time.parse('23:59:59')
  end

  def out_of_service?(date_time)
    booking_date = date_time.to_date.to_s
    booking_time = date_time.to_time.to_s
    activity.out_of_service?(booking_date, booking_time, interval)
  end
end
