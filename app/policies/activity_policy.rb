class ActivityPolicy < ApplicationPolicy
  def index?
    is_activity_belongs_to_user?
  end

  def new?
    is_activity_belongs_to_user?
  end

  private

  def is_activity_belongs_to_user?
    user == record.business.user
  end
end
