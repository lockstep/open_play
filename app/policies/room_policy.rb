class RoomPolicy < ApplicationPolicy
  def create?
    is_room_belongs_to_user?
  end

  def update?
    is_room_belongs_to_user?
  end

  def destroy?
    is_room_belongs_to_user?
  end

  private

  def is_room_belongs_to_user?
    user == record.activity.business.user
  end
end
