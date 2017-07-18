module LocationConcerns
  extend ActiveSupport::Concern

  def current_address
    session_address || address
  end

  def current_latitude
    session_latitude || latitude
  end

  def current_longitude
    session_longitude || longitude
  end
end
