class Activity < ApplicationRecord
  belongs_to :business
  validates_presence_of :name, :start_time, :end_time
  validate :end_time_need_to_scheduled_after_start_time

  def end_time_need_to_scheduled_after_start_time
    if errors.empty? && ( end_time.seconds_since_midnight.to_i <=
      start_time.seconds_since_midnight.to_i)
      errors.add(:end_time, "can't be scheduled before or equal start_time")
    end
  end
end
