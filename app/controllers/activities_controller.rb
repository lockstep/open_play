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
      redirect_back fallback_location: :back, error: 'Unable to update activity'
    end
  end

  def destroy
    if @activity.update(archived: true)
      redirect_back fallback_location: :back, notice: 'Successfully deleted activity'
    else
      redirect_back fallback_location: :back, error: 'Unable to delete reservable'
    end
  end

  def search
    @date = params[:activity][:date]
    @activities = Activity.all.active
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
      :prevent_back_to_back_booking
    ]
    params.require(:activity).permit(permitted_params)
  end
end
