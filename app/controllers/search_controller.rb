class SearchController < ApplicationController

  def search
    @booking_date = params[:booking_date]
    @booking_time = params[:booking_time]
    unless @booking_date.present?
      redirect_to root_path, alert: 'Date is required.'
    end
    @activities = Activity.search(@booking_time, params[:activity_type])
  end
end
