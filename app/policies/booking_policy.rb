class BookingPolicy < ApplicationPolicy
  def checked_in?
    belongs_to_user?
  end

  private

  def belongs_to_user?
    user == record.reservable.user
  end
end
