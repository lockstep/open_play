class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_time_slot_selection_is_present, only: [:new]

  def new
    @order = Order.new()
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
      redirect_to orders_success_path
    else
      render :new
    end
  end

  def success
  end

  def verify_order
    order = Order.new(order_params)
    if order.valid?
      render json: order, status: :ok
    else
      render json: { meta: { errors: order.errors.full_messages }}, status: :unprocessable_entity
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

  def order_params
    params.require(:order).permit(:user_id, bookings_attributes: [
      :start_time, :end_time, :booking_date, :number_of_players, :reservable_id]
    )
  end
end
