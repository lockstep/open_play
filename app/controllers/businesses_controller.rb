class BusinessesController < ApplicationController
  before_action :authenticate_user!

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

  private

  def business_params
    permitted_params = [:name, :description]
    params.require(:business).permit(permitted_params)
  end
end
