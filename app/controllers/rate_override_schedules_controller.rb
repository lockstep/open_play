class RateOverrideSchedulesController < ApplicationController
  before_action :authenticate_user!

  def index
    activity = Activity.find(params[:activity_id])
    @rate_schedules = activity.rate_override_schedules
    @rate_schedule = RateOverrideSchedule.new(overridden_specific_day: true,
      overridden_all_day: true, activity_id: activity.id)
    authorize @rate_schedule
  end

  def create
    @rate_schedule = RateOverrideSchedule.new(schedule_params)
    authorize @rate_schedule
    activity = @rate_schedule.activity
    if @rate_schedule.save
      redirect_to activity_rate_override_schedules_path(activity),
        notice: 'Rate override schedule was created.'
    else
      @rate_schedules = activity.rate_override_schedules
      render :index
    end
  end

  def destroy
    @rate_schedule = RateOverrideSchedule.find(params[:id])
    authorize @rate_schedule
    if @rate_schedule.destroy
      activity = Activity.find(@rate_schedule.activity.id)
      redirect_to activity_rate_override_schedules_path(activity),
        notice: 'Rate override schedule was deleted.'
    end
  end

  private

  def schedule_params
    params.require(:rate_override_schedule).permit(:label, :overridden_on, :overridden_all_day,
    :overridden_specific_day, :overriding_begins_at, :overriding_ends_at, :activity_id,
    :price, :per_person_price, :overridden_all_reservables, overridden_days: [],
    overridden_reservables: [])
  end
end
