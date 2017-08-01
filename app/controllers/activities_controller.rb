class ActivitiesController < ApplicationController
  include DateTimeHelper
  before_action :authenticate_user!
  before_action :set_business, only: [:index, :new, :create]
  before_action :set_activity, only: [:destroy, :edit, :update, :view_analytics]
  after_action :verify_authorized

  def index
    @activities = @business.activities.active
    authorize @business.activities.build
  end

  def new
    @activity = @business.activities.build
    authorize @activity
  end

  def create
    @activity = @business.activities.build(activity_params)
    authorize @activity
    if @activity.save
      redirect_to business_activities_path, notice: 'Successfully created activity'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @activity.update(activity_params)
      redirect_to business_activities_path(@activity.business),
        notice: 'Successfully updated activity'
    else
      render :edit
    end
  end

  def destroy
    if @activity.update(archived: true)
      redirect_back fallback_location: root_path, notice: 'Successfully deleted activity'
    else
      flash[:error] = 'Unable to delete activity'
      redirect_back fallback_location: root_path
    end
  end

  def view_analytics
    bookings = Booking.belongs_to_activity(@activity)
    booking_data = bookings.revenues_by_date_in_60_days
    @booking_dates = booking_data.collect { |key,value|
      present_date_in_day_month_year_format(key)
    }
    @booking_revenues = booking_data.values
  end

  private

  def set_activity
    @activity = Activity.find_by_id(params[:id])
    authorize @activity
  end

  def set_business
    @business = Business.find(params[:business_id])
  end

  def activity_params
    permitted_params = %i[name picture description start_time end_time type
      prevent_back_to_back_booking allow_multi_party_bookings]
    params.require(:activity).permit(permitted_params)
  end
end
