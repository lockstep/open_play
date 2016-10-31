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
  validates :weekday_price, numericality: { greater_than: 0 }
  validates :weekend_price, numericality: { greater_than: 0 }
  validate :end_time_is_after_start_time

  delegate :name, to: :activity, prefix: true
  delegate :allow_multi_party_bookings, to: :activity
  delegate :user, to: :activity
  scope :active, -> { where(archived: false) }

  def end_time_is_after_start_time
    return unless start_time.present? && end_time.present?
    unless start_time < end_time
      errors.add(:end_time, 'must be after the start time')
    end
  end

  def number_of_booked_players(start_time, end_time, date)
    bookings
      .during(start_time, end_time, date)
      .sum("number_of_players")
  end

  def available_players(start_time, end_time, date)
    maximum_players - number_of_booked_players(start_time, end_time, date)
  end
end
