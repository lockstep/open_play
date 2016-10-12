class ReservablesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @reservable = current_activity.build_reservable
  end

  def create
    @reservable = current_activity.build_reservable
    if @reservable.update_attributes(reservable_params(@reservable))
      options = params[:options]
      unless options.nil?
        options.each do |option|
          @reservable.options_available.create(
            reservable_option_id: option
          )
        end
      end
      redirect_to business_activities_path(current_activity.business),
        :notice => "#{@reservable.type} was successfully added."
    else
      render :new
    end
  end

  private

  def current_activity
    @current_activity ||= Activity.find_by_id(params[:activity_id])
  end

  def reservable_params(reservable)
    case reservable
    when Lane
      reservable_type = :lane
    when Room
      reservable_type = :room
    end
    params.require(reservable_type)
      .permit([
        :name,
        :interval,
        :start_time,
        :end_time,
        :maximum_players,
        :weekday_price,
        :weekend_price
      ])
  end

end
