class ActivityDecorator < Draper::Decorator
  delegate_all

  def number_of_normal_reservables
    object.reservables.where.not(type: Reservable::PARTY_ROOM_TYPE).count
  end

  def number_of_party_rooms
    object.reservables.where(type: Reservable::PARTY_ROOM_TYPE).count
  end
end
