class Room < Reservable
  validates :maximum_players, numericality: { only_integer: true, greater_than: 0 }

  def number_of_booked_players(start_time, end_time, date)
    bookings
      .on_date_time(start_time, end_time, date)
      .sum("number_of_players")
  end

  def available_players(start_time, end_time, date)
    self.maximum_players - number_of_booked_players(start_time, end_time, date)
  end
end
