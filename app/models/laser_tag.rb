class LaserTag < Activity
  has_many :rooms, foreign_key: 'activity_id'

  def reservable_type
    Room
  end
end
