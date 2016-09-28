class Bowling < Activity
  has_many :lanes, foreign_key: 'activity_id'
  def build_reservable
    lane = lanes.new
    lane.start_time = self.start_time
    lane.end_time = self.end_time
    lane
  end
  def reservable_type
    Lane
  end
end
