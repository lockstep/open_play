class Activity < ApplicationRecord
  belongs_to :business
  validates_presence_of :name
  validate :end_time_is_after_start_time

  def self.types
    %w(Bowling LaserTag)
  end

  def end_time_is_after_start_time
    if ( end_time.seconds_since_midnight.to_i <=
      start_time.seconds_since_midnight.to_i)
      errors.add(:end_time, 'must be after the start time')
    end
  end
end
