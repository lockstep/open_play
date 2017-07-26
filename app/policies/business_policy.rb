class BusinessPolicy < ApplicationPolicy
  def update?
    belongs_to_user?
  end
end
