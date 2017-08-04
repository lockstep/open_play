class Reservable < ApplicationRecord
  include TimeValidations
  include SubReservablesConcerns

  PARTY_ROOM_TYPE = 'PartyRoom'.freeze

  belongs_to :activity
  has_many :options, foreign_key: 'reservable_type', primary_key: 'type',
           class_name: 'ReservableOption'
  has_many :options_available, class_name: 'ReservableOptionsAvailable'
  has_many :bookings

  validates_presence_of :name
  validates :interval, numericality: { only_integer: true }
  validates :maximum_players, numericality: { only_integer: true, greater_than: 0 }

  delegate :name, to: :activity, prefix: true
  delegate :type, to: :activity, prefix: true
  delegate :allow_multi_party_bookings, to: :activity
  delegate :user, to: :activity

  accepts_nested_attributes_for :options_available

  monetize :weekday_price_cents,
           :weekend_price_cents,
           :per_person_weekday_price_cents,
           :per_person_weekend_price_cents,
           numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(archived: false) }

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

  def closed_schedules
    ClosedSchedule.find_by_activity_or_reservable(self)
  end

  def out_of_service?(date_time)
    closed_schedules.any? do |schedule|
      schedule.match?(date_time.to_date.to_s, date_time.to_time.to_s, interval)
    end
  end

  def self.list_reservable_names_by_ids(reservable_ids)
    where(id: reservable_ids).order(:name).pluck(:name)
  end

  def rate_override_schedule(date, time)
    schedules = RateOverrideSchedule.find_by_activity_or_reservable(activity.id, id)
    schedules.find { |schedule| schedule.match?(date, time, interval) }
  end

  def party_room?
    type == PARTY_ROOM_TYPE
  end
end
