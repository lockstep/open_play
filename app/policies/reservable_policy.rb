class ReservablePolicy < ApplicationPolicy
  def create?
    belongs_to_user?
  end

  def update?
    belongs_to_user?
  end

  def destroy?
    belongs_to_user?
  end
end
