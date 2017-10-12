class SearchController < ApplicationController
  def search
    current_user&.update_session_location(location_params)
    @booking_date = params[:booking_date]
    redirect_to root_path,
      alert: 'Date is required.' and return true unless @booking_date.present?
    @booking_time = params[:booking_time]
    @activities = Activity.search_by_type_within_area(
      location_params.merge(date: @booking_date)
    )
  end

  def paginate_reservables
    @booking_date = params[:booking_date]
    @booking_time = params[:booking_time]
    @activity = Activity.find(params[:activity_id])
    @reservables = @activity.reservables.active.order(:name).page(params[:page]).per(5)
    respond_to do |format|
      format.js
    end
  end

  private

  def location_params
    params.permit(:address, :latitude, :longitude, :activity_type)
  end
end
