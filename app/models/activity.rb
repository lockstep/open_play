class Activity < ApplicationRecord
  belongs_to :business
  has_many :reservables, dependent: :destroy
  has_many :orders
  has_many :closed_schedules, dependent: :destroy
  validates_presence_of :name
  validate :end_time_is_after_start_time
  scope :active, -> { where(archived: false) }
  delegate :user, to: :business

  def self.types
    %w(bowling laser_tag)
  end

  def self.search(booking_date, booking_time, activity_type)
    unless booking_time.present?
      return Activity.active.where("type = ?", activity_type)
    end
    activities = Activity.active.where("type = ? AND (start_time <= ? AND end_time > ?)
      OR (start_time = end_time)", activity_type, booking_time, booking_time)
    filter_activities_by_closed_schedules(activities, booking_date, booking_time)
  end

  def self.filter_activities_by_closed_schedules(activities, booking_date, booking_time)
    activities.select { |activity| !activity.out_of_service?(booking_date, booking_time) }
  end

  def out_of_service?(booking_date, booking_time)
    closed_schedules.any? { |schedule| schedule.match?(booking_date, booking_time) }
  end

  def end_time_is_after_start_time
    if ( end_time.seconds_since_midnight.to_i <
      start_time.seconds_since_midnight.to_i)
      errors.add(:end_time, 'must be after the start time')
    end
  end

end
