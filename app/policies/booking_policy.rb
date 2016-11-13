class BookingPolicy < ApplicationPolicy
  def check_in?
    belongs_to_user?
  end

  private

  def belongs_to_user?
    user == record.reservable.user
  end
end
