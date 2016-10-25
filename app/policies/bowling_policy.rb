class BowlingPolicy < ApplicationPolicy
  def create?
    is_bowling_belongs_to_user?
  end

  def update?
    is_bowling_belongs_to_user?
  end

  def destroy?
    is_bowling_belongs_to_user?
  end

  private

  def is_bowling_belongs_to_user?
    user == record.business.user
  end
end
