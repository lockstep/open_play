class Activity < ApplicationRecord
  belongs_to :business
  has_many :reservables
  has_many :orders
  validates_presence_of :name
  validate :end_time_is_after_start_time
  scope :active, -> { where(archived: false) }
  def self.types
    %w(bowling laser_tag)
  end

  def end_time_is_after_start_time
    if ( end_time.seconds_since_midnight.to_i <=
      start_time.seconds_since_midnight.to_i)
      errors.add(:end_time, 'must be after the start time')
    end
  end

  def self.search(booking_time, activity_type)
    return Activity.where("type = ?", activity_type) unless booking_time.present?
    Activity.where("type = ? AND start_time <= ? AND end_time > ?",
      activity_type, booking_time, booking_time)
  end

end
