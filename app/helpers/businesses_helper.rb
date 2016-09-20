module BusinessesHelper
  def manages_business?
    current_user.business.try(:persisted?)
  end
end
