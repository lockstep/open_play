class ClosedSchedulesController < ApplicationController
  before_action :authenticate_user!

  def index
    activity = Activity.find(params[:activity_id])
    @schedules = activity.closed_schedules
    @schedule = ClosedSchedule.new(closed_specific_day: true,
      closed_all_day: true, activity_id: activity.id)
    authorize @schedule
  end

  def create
    @schedule = ClosedSchedule.new(schedule_params)
    authorize @schedule
    activity = @schedule.activity
    if @schedule.save
      redirect_to activity_closed_schedules_path(activity),
        notice: 'Closing time scheduled successfully.'
    else
      @schedules = activity.closed_schedules
      render :index
    end
  end

  def destroy
    @schedule = ClosedSchedule.find(params[:id])
    authorize @schedule
    if @schedule.destroy
      activity = Activity.find(@schedule.activity.id)
      redirect_to activity_closed_schedules_path(activity),
        notice: 'Closing time deleted.'
    end
  end

  private

  def schedule_params
    params.require(:closed_schedule).permit(:label, :closed_on, :closed_all_day,
    :closed_specific_day, :closing_begins_at, :closing_ends_at, :activity_id,
    closed_days: [])
  end
end
