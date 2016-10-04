class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_time_slots_are_exist?, only: [:new]

  def new
    @order = Order.new()
    params[:time_slots].each do |reservable_id, reservable_time_slots|
      reservable_time_slots.each do |time_slots|
        @order.bookings.build(
          reservable_id: reservable_id,
          start_time: extract_time_slots(time_slots, 'start_time'),
          end_time: extract_time_slots(time_slots, 'end_time'),
          booking_date: params[:date],
          players: 1
        )
      end
    end
  end

  def create
    @order = Order.new(order_params.merge({ user_id: current_user.id }))
    if @order.save
      redirect_to orders_thank_path
    else
      render :new
    end
  end

  def thank
  end

  private

  def check_time_slots_are_exist?
    redirect_back(
      fallback_location: root_path,
      alert: "Couldn't booking, please select any time slots"
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
    params.require(:order).permit(bookings_attributes: [
      :start_time, :end_time, :booking_date, :players, :reservable_id
    ])
  end
end
