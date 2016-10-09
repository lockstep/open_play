class Room < Reservable
  validates :maximum_players, numericality: { only_integer: true, greater_than: 0 }

  def number_of_booked_players
    bookings.sum("number_of_players")
  end

  def available_players
    self.maximum_players - number_of_booked_players
  end
end
