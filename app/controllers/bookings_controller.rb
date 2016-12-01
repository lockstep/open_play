class BookingsController < ApplicationController
  before_action :authenticate_user!

  def check_in
    booking = Booking.find(params[:id])
    authorize booking
    booking.update(checked_in: true)
    redirect_back fallback_location: root_path, notice: 'Successfully checked in'
  end

  def cancel
    booking = Booking.find(params[:id])
    authorize booking
    booking.update(canceled: true)
    redirect_back fallback_location: root_path, notice: 'Successfully canceled'
  end
end
