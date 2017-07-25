module UserLocationConcerns
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

  def update_session_location(location_params = {})
    update(
      session_address: location_params[:address],
      session_latitude: location_params[:latitude],
      session_longitude: location_params[:longitude],
      last_searched_at: Time.now
    )
  end

  def should_reset_session_location?
    last_searched_at && last_searched_at < 4.hours.ago
  end
end
