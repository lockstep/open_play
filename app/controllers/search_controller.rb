class SearchController < ApplicationController

  def search
    @booking_date = params[:booking_date]
    @booking_time = params[:booking_time]
    activity_type = params[:activity_type]
    @activities = Activity.search(@booking_date, @booking_time, activity_type)
  end

end
