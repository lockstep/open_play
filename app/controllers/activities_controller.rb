class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_business, only: [:index]

  def index
    @activities = @business.activities
  end

  private

  def set_business
    @business = Business.find(params[:business_id])
  end
end
