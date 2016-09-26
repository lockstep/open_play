class Bowling < Activity
  has_many :lanes
  delegate :lanes, to: :reservables
end
