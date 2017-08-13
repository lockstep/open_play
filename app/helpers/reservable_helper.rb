module ReservableHelper
  def sub_reservable_list(reservable)
    Reservable.where(activity_id: reservable.activity_id).order(:id)
  end

  def maximum_players(reservable)
    return reservable.maximum_players unless reservable.party_room?
    reservable.virtual_maximum_players
  end
end
