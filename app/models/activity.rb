class Activity < ApplicationRecord
  belongs_to :business
  validates_presence_of :name, :activity_type
  validate :end_time_is_after_start_time

  ACTIVITY_TYPES = ['Bowling', 'Laser Tag']

  def end_time_is_after_start_time
    if ( end_time.seconds_since_midnight.to_i <=
      start_time.seconds_since_midnight.to_i)
      errors.add(:end_time, 'must be after the start time')
    end
  end
end
