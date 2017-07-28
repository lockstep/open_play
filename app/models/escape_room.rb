class EscapeRoom < Activity
  has_many :rooms, foreign_key: 'activity_id'

  def build_reservable
    room = rooms.new
    room.start_time = self.start_time
    room.end_time = self.end_time
    room
  end

  def reservable_type
    Room
  end
end
