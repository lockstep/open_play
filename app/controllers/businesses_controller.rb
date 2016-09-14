class BusinessesController < ApplicationController
  before_action :authenticate_user!

  def index
    @businesses = current_user.businesses
  end

  def new
    @business = current_user.businesses.build
  end

  def create
    @business = current_user.businesses.build(business_params)
    if @business.save
      redirect_to businesses_path, :notice => 'Successfully created business'
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
