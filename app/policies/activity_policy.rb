class ActivityPolicy < ApplicationPolicy
  def index?
    belongs_to_user?
  end

  def new?
    belongs_to_user?
  end

  def create?
    belongs_to_user?
  end

  def update?
    belongs_to_user?
  end

  def destroy?
    belongs_to_user?
  end

  private

  def belongs_to_user?
    user == record.user
  end
end
