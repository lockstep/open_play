class Reservable < ApplicationRecord
  belongs_to :activity
  has_many :options,
    foreign_key: 'reservable_type',
    primary_key: 'type',
    class_name: 'ReservableOption'
  has_many :options_availables, class_name: 'ReservableOptionsAvailable'
  has_many :bookings

  validates :interval, numericality: { only_integer: true }
  validates :maximum_players, numericality: { only_integer: true, greater_than: 0 }
  validate :end_time_is_after_start_time

  delegate :name, to: :activity, prefix: true

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

  def is_a_room?
    self.instance_of?(Room)
  end
end
