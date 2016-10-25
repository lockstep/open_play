class BusinessesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_business, only: [:edit, :update, :show]
  def new
    @business = current_user.build_business
  end

  def create
    @business = current_user.build_business(business_params)
    if @business.save
      redirect_to business_activities_path(@business),
        :notice => 'Successfully created business'
    else
      render :new
    end
  end
  def edit; end

  def update
    if @business.update(business_params)
      redirect_to businesses_show_path,
        :notice => 'Successfully updated business'
    else
      render :edit
    end
  end

  def show; end

  private

  def set_business
    @business = current_user.business
  end

  def business_params
    permitted_params = [
      :name,
      :description,
      :profile_picture,
      :phone_number,
      :address
    ]
    params.require(:business).permit(permitted_params)
  end
end
