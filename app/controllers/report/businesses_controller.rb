module Report
  class BusinessesController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def index
      @filter = OrderFilter.new(order_filter_params)
      @businesses = Business.with_activity(@filter.activity_type)
                            .page(params[:page]).per(10)
      @orders = Order.of_businesses(@businesses.ids)
                     .claimable_during(@filter.from_date,
                                       @filter.to_date)
    end

    def order_filter_params
      return unless params.has_key?(:order_filter)
      params.require(:order_filter).permit(
        :from_date, :to_date, :activity_type
      )
    end

    def require_admin
      user_not_authorized unless current_user.admin
    end
  end
end
