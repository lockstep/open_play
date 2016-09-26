class LaserTag < Activity
  has_many :rooms
  delegate :rooms, to: :reservables
end
