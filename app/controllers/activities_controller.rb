class ActivitiesController < ApplicationController
  before_action :authenticate_user!, except: [:search]
  before_action :set_business, only: [:index, :new, :create]
  before_action :set_activity, only: [:destroy, :edit, :update]

  def index
    @activities = @business.activities.active
  end

  def new
    @activity = @business.activities.build
  end

  def create
    @activity = @business.activities.build(activity_params)
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

  private

  def set_activity
    @activity = Activity.find_by_id(params[:id])
  end
  def set_business
    @business = Business.find(params[:business_id])
  end

  def activity_params
    permitted_params = [
      :name,
      :start_time,
      :end_time, :type,
      :prevent_back_to_back_booking,
      :allow_multi_party_bookings
    ]
    params.require(:activity).permit(permitted_params)
  end
end
