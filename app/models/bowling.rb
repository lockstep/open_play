class Bowling < Activity
  has_many :lanes, foreign_key: 'activity_id'

  def reservable_type
    Lane
  end
end
