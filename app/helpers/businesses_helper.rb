module BusinessesHelper
  def manages_business?
    current_user.business && current_user.business.persisted?
  end
end
