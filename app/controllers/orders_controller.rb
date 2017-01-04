class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:reservations_for_business_owner,
    :reservations_for_users]
  before_action :verify_user_on_reservations_page, only: [:reservations_for_business_owner,
    :reservations_for_users]
  before_action :ensure_time_slot_selection_is_present, only: [:new]
  before_action :set_booking_date, only: [:reservations_for_business_owner,
    :reservations_for_users]
  before_action :set_order, only: [:create, :prepare_complete_order]

  def new
    @order = Order.new(activity_id: params[:activity_id])
    @order.bookings = ConsolidateBookings.new(
      params[:time_slots], params[:date]).call
  end

  def create
    fulfill_order
    if @order.save
      @order.process_order(params[:token_id])
      redirect_to success_order_path(@order), notice: thank_you_message
    else
      render :new
    end
  rescue Stripe::CardError
    render :new
  end

  def success
    @order = Order.find(params[:id])
  end

  def reservations_for_business_owner
    @bookings = Order.reservations_for_business_owner(@date, params[:activity_id])

    respond_to do |format|
      format.html
      format.xls { headers['Content-Type'] = 'application/xls' }
      format.csv do
        send_data ReservationCsvRenderer.new.generate_csv(@bookings)
        headers['Content-Type'] = 'text/csv'
      end
    end
  end

  def reservations_for_users
    @bookings = Order.reservations_for_users(@date, params[:user_id])
  end

  def prepare_complete_order
    if @order.valid?
      if user_signed_in?
        order_is_ready_to_book!
      else
        # TODO: Refactor this disgusting if/else tree.
        guest = Guest.new(guest_params[:guest])
        if guest.valid?
          order_is_ready_to_book!
        else
          render json: { meta: { errors: guest.errors.full_messages }},
            status: :unprocessable_entity
        end
      end
    else
      render json: { meta: { errors: @order.errors.full_messages }},
        status: :unprocessable_entity
    end
  end

  private

  def order_is_ready_to_book!
    render json: {
      meta: {
        number_of_bookings: @order.bookings.length,
        total_price: @order.calculate_cost(current_user),
        email: user_signed_in? ? current_user.email : params[:guest][:email]
      }
    }
  end

  def ensure_time_slot_selection_is_present
    redirect_back(
      fallback_location: root_path,
      alert: "Please select at least one time slot."
    ) if params[:time_slots].nil?
  end

  def set_booking_date
    @date = params[:booking_date] || DateTime.now.to_formatted_s(:rfc822)
  end

  def order_params
    params.require(:order).permit(:activity_id, bookings_attributes: [
      :start_time, :end_time, :booking_date, :number_of_players, :reservable_id,
      reservable_options_attributes: [:reservable_option_id]
    ])
  end

  def guest_params
    params.permit(guest: [:first_name, :last_name, :email, :phone_number])
  end

  def set_order
    @order = Order.new(order_params)
  end

  def set_user_or_guest
    if user_signed_in?
      @order.user = current_user
    else
      @order.guest = Guest.create(guest_params[:guest])
    end
  end

  def fulfill_order
    set_user_or_guest
    @order.set_price_of_bookings
  end

  def thank_you_message
    <<-EOS
      Thank you for your reservation!
      You will receive an email confirmation shortly.
    EOS
  end

  def verify_user_on_reservations_page
    if params[:user_id] && params[:user_id] != current_user.id.to_s
      unauthorized_access_an_action
    elsif params[:activity_id] && Activity.find(params[:activity_id]).user != current_user
      unauthorized_access_an_action
    end
  end

  def unauthorized_access_an_action
    flash[:alert] =  "You are not authorized to perform this action."
    redirect_to root_path and return
  end
end
