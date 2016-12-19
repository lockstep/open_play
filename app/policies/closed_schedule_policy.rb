class ClosedSchedulePolicy < ApplicationPolicy
  def index?
    belongs_to_user?
  end

  def create?
    belongs_to_user?
  end

  def destroy?
    belongs_to_user?
  end
end
