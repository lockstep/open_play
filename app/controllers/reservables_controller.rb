class ReservablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservable, only: [:edit, :update, :destroy]
  after_action :verify_authorized

  def new
    @reservable = current_activity.build_reservable(params[:type])
    authorize @reservable
    @sub_reservables = BuildSubReservablesService.new(
      @reservable, nil, action_name
    ).call
  end

  def create
    @reservable = current_activity.build_reservable(params[:type])
    authorize @reservable
    if @reservable.validate_sub_reservables(reservable_params) &&
       @reservable.update_attributes(reservable_params.except(:sub_reservables))
      @reservable.assign_sub_reservables(reservable_params)
      params[:options]&.each do |option|
        @reservable.options_available.create(reservable_option_id: option)
      end
      redirect_to business_activities_path(current_activity.business),
        notice: "#{@reservable.type} was successfully added."
    else
      @sub_reservables = BuildSubReservablesService.new(
        @reservable, reservable_params, action_name
      ).call
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
    permitted_params = [
      :name,
      :description,
      :maximum_players_per_sub_reservable,
      :interval,
      :start_time,
      :end_time,
      :maximum_players,
      :weekday_price,
      :weekend_price,
      :per_person_weekday_price,
      :per_person_weekend_price,
      sub_reservables: %i[id priority_number]
    ]
    params.require(:reservable).permit(permitted_params)
  end
end
