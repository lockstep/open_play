module ReservableHelper
  def maximum_players(reservable)
    return reservable.maximum_players unless reservable.party_room?
    reservable.virtual_maximum_players
  end

  def reservable_name(reservable)
    reservable.type.titleize
  end
end
