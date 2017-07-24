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

    def date_from_param(param)
      return Date.today.to_formatted_s(:db) if param.blank?
      param
    end

    def order_filter_params
      if params.has_key? :order_filter
        return params.require(:order_filter).permit(
          :from_date, :to_date, :activity_type
        )
      end
    end

    def require_admin
      user_not_authorized unless current_user.admin
    end
  end
end
