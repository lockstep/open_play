class LanePolicy < ApplicationPolicy
  def create?
    is_lane_belongs_to_user?
  end

  def update?
    is_lane_belongs_to_user?
  end

  def destroy?
    user == record.activity.business.user
  end

  private

  def is_lane_belongs_to_user?
    user == record.activity.business.user
  end
end
