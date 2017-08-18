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

  def allocate_reservables(number_of_players)
    allocated_reservable = {}
    total_required_reservables =
      (number_of_players.to_f / maximum_players_per_sub_reservable).ceil
    remain_players = number_of_players
    reservables =
      children.order(:priority_number).take(total_required_reservables)
    reservables.each do |reservable|
      if remain_players / maximum_players_per_sub_reservable >= 1
        allocated_count = maximum_players_per_sub_reservable
        remain_players -= maximum_players_per_sub_reservable
      else
        allocated_count = remain_players % maximum_players_per_sub_reservable
      end
      allocated_reservable[reservable.sub_reservable_id.to_s] = allocated_count
    end
    allocated_reservable
  end

  def sub_reservables_type
    activity.reservables.first.type
  end

  def sub_reservables_candidate
    Reservable
      .where('activity_id = ? AND type != ?', activity_id,
             Reservable::PARTY_ROOM_TYPE)
      .order(:id)
  end
end
