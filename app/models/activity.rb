class Activity < ApplicationRecord
  belongs_to :business
  has_many :reservables
  validates_presence_of :name
  validate :end_time_is_after_start_time

  def self.types
    %w(bowling laser_tag)
  end

  def end_time_is_after_start_time
    if ( end_time.seconds_since_midnight.to_i <=
      start_time.seconds_since_midnight.to_i)
      errors.add(:end_time, 'must be after the start time')
    end
  end

  def build_reservable
    case self
    when Bowling
      self.lanes.new
    when LaserTag
      self.rooms.new
    else
      self.reservables.new
    end
  end

end
