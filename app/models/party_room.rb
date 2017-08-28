class PartyRoom < Reservable
  validates :maximum_players_per_sub_reservable, numericality: {
    only_integer: true, greater_than: 0 }

  def virtual_maximum_players
    total_players_of_sub_reservables =
      maximum_players_per_sub_reservable * sub_reservables.count
    return maximum_players if maximum_players <= total_players_of_sub_reservables
    total_players_of_sub_reservables
  end

  def bookings
    Booking.where(reservable_id: [id] + sub_reservables.ids)
  end
end
