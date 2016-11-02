class SearchController < ApplicationController

  def search
    @booking_date = params[:booking_date]
    @booking_time = params[:booking_time]
    unless @booking_date.present?
      redirect_to root_path, alert: 'Date is required.'
    end
    @number_of_reservables_per_page = number_of_reservables_per_page
    @activities = Activity.search(@booking_time, params[:activity_type])
  end

  def get_more_reservables
    @booking_date = params[:booking_date]
    @booking_time = params[:booking_time]
    activity = Activity.find(params[:activity_id])
    @reservables = activity.reservables.active.order(:name)
      .offset(number_of_reservables_per_page)
    respond_to do |format|
      format.js
    end
  end

  private

  def number_of_reservables_per_page
    2
  end
end
