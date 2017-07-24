class OrderPolicy < ApplicationPolicy
  def manage?
    user.admin?
  end
end
