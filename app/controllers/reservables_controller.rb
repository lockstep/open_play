class ReservablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservable, only: [:edit, :update, :destroy]
  after_action :verify_authorized

  def new
    @reservable = current_activity.build_reservable
    authorize @reservable
  end

  def create
    @reservable = current_activity.build_reservable
    authorize @reservable
    if @reservable.update_attributes(reservable_params)
      options = params[:options]
      unless options.nil?
        options.each do |option|
          @reservable.options_available.create(
            reservable_option_id: option
          )
        end
      end
      redirect_to business_activities_path(current_activity.business),
        notice: "#{@reservable.type} was successfully added."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @reservable.update_attributes(reservable_params)
      options = params[:options]
      @reservable.options_available.destroy_all unless @reservable.options_available.nil?

      unless options.nil?
        options.each do |option|
          unless @reservable.options_available.find_by(reservable_option_id: option).present?
            @reservable.options_available.create(
              reservable_option_id: option
            )
          end
        end
      end

      redirect_to edit_activity_path(@reservable.activity),
        notice: 'Successfully updated reservable'
    else
      render :edit
    end
  end

  def destroy
    if @reservable.update(archived: true)
      redirect_back fallback_location: root_path, notice: 'Successfully deleted reservable'
    else
      flash[:error] = 'Unable to delete activity'
      redirect_back fallback_location: root_path
    end
  end

  private

  def set_reservable
    @reservable = Reservable.find_by_id(params[:id])
    authorize @reservable
  end

  def current_activity
    @current_activity ||= Activity.find_by_id(params[:activity_id])
  end

  def reservable_params
    params.require(:reservable)
      .permit([
        :name,
        :interval,
        :start_time,
        :end_time,
        :maximum_players,
        :weekday_price,
        :weekend_price,
        :per_person_weekday_price,
        :per_person_weekend_price
      ])
  end

end
