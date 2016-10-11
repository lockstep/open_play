class ActivitiesController < ApplicationController
  before_action :authenticate_user!, except: [:search]
  before_action :set_business, only: [:index, :new, :create]

  def index
    @activities = @business.activities
  end

  def new
    @activity = @business.activities.build
  end

  def create
    @activity = @business.activities.build(activity_params)
    if @activity.save
      redirect_to business_activities_path, :notice => 'Successfully created activity'
    else
      render :new
    end
  end

  def search
    @date = params[:activity][:date]
    @activities = Activity.all
  end

  private

  def set_business
    @business = Business.find(params[:business_id])
  end

  def activity_params
    permitted_params = [:name, :start_time, :end_time, :type,
      :prevent_back_to_back_booking]
    params.require(:activity).permit(permitted_params)
  end
end
