class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:reservations_for_business_owner,
    :reservations_for_users]
  before_action :ensure_time_slot_selection_is_present, only: [:new]
  before_action :set_booking_date, only: [:reservations_for_business_owner,
    :reservations_for_users]

  def new
    @guest_user = User.get_guest_user unless user_signed_in?
    @order = Order.new(activity_id: params[:activity_id])
    params[:time_slots].each do |reservable_id, reservable_time_slots|
      reservable_time_slots.each do |time_slots|
        @order.bookings.build(
          reservable_id: reservable_id,
          start_time: extract_time_slots(time_slots, 'start_time'),
          end_time: extract_time_slots(time_slots, 'end_time'),
          booking_date: params[:date],
          number_of_players: 1
        )
      end
    end
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      Stripe::Charge.create(
        amount: @order.total_price_in_cents.to_i,
        currency: 'usd',
        source: params[:token_id]
      )
      redirect_to orders_success_path
    else
      render :new
    end
  rescue Stripe::CardError
    render :new
  end

  def success
  end

  def reservations_for_business_owner
    @orders = Order.reservations_for_business_owner(@date, params[:activity_id])
    respond_to do |format|
      format.html
      format.xls { headers['Content-Type'] = 'application/xls' }
      format.csv do
        send_data @orders.to_csv
        headers['Content-Type'] = 'text/csv'
      end
    end
  end

  def reservations_for_users
    @orders = Order.reservations_for_users(@date, params[:user_id])
  end

  def prepare_complete_order
    order = Order.new(order_params)
    if order.valid?
      render json: { meta: {
          number_of_bookings: order.bookings.length,
          total_price: order.total_price_in_cents
        }
      }, status: :ok
    else
      render json: { meta: { errors: order.errors.full_messages }},
        status: :unprocessable_entity
    end
  end

  private

  def ensure_time_slot_selection_is_present
    redirect_back(
      fallback_location: root_path,
      alert: "Please select at least one time slot."
    ) if params[:time_slots].nil?
  end

  def extract_time_slots(time_slots, slot)
    array_of_time_slots = time_slots.split(',')
    if slot == "start_time"
      array_of_time_slots[0]
    else
      array_of_time_slots[1]
    end
  end

  def set_booking_date
    @date = params[:booking_date] || DateTime.now.to_formatted_s(:rfc822)
  end

  def order_params
    params.require(:order).permit(:user_id, :activity_id, :guest_first_name,
      :guest_last_name, :guest_email, bookings_attributes: [
      :start_time, :end_time, :booking_date, :number_of_players, :reservable_id,
      reservable_options_attributes: [:reservable_option_id]
    ])
  end
end
