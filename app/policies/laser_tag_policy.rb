class LaserTagPolicy < ApplicationPolicy
  def create?
    is_laser_tag_belongs_to_user?
  end

  def update?
    is_laser_tag_belongs_to_user?
  end

  def destroy?
    is_laser_tag_belongs_to_user?
  end

  private

  def is_laser_tag_belongs_to_user?
    user == record.business.user
  end
end
