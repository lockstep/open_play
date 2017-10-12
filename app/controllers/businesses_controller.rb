class BusinessesController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_business, only: %i[edit update show]
  after_action :verify_authorized, only: %i[edit update]

  def new
    @business = current_user.build_business
  end

  def create
    @business = current_user.build_business(business_params)
    if @business.save
      redirect_to business_activities_path(@business),
        notice: 'Successfully created business'
    else
      render :new
    end
  end

  def edit
    authorize @business
  end

  def update
    authorize @business
    if @business.update(business_params)
      redirect_to @business, notice: 'Successfully updated business'
    else
      render :edit
    end
  end

  def show
    @booking_date = Date.parse(params[:booking_date] || Date.today.to_s).to_s
    @booking_time = params[:booking_time] || Time.current.strftime("%H:%M")
    @activities = Activity.search_by_business(@business.id, @booking_date)
  end

  private

  def set_business
    @business = Business.find(params[:id])
  end

  def business_params
    permitted_params = %i[
      name description profile_picture phone_number address_line_one
      city state zip country latitude longitude
    ]
    params.require(:business).permit(permitted_params)
  end
end
