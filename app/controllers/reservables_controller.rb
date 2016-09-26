class ReservablesController < ApplicationController
  def new
    @reservable = current_activity.build_reservable
  end

  def create
    @reservable = current_activity.build_reservable
    if @reservable.update_attributes(reservable_params)
      options = params[:options]
      unless options.nil?
        options.each do |option|
          @reservable.options_availables.create(
            reservable_option_id: option
          )
        end
      end
      redirect_to business_activities_path(current_activity.business),
        :notice => 'Reservable was successfully added.'
    else
      render :new
    end
  end

  private

  def current_activity
    @current_activity ||= Activity.find_by_id(params[:activity_id])
  end

  def reservable_params
    params.require(:reservable)
      .permit([
        :name,
        :interval,
        :start_time,
        :end_time
      ])
  end

end
