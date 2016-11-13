class BookingsController < ApplicationController
  before_action :authenticate_user!

  def check_in
    booking = Booking.find(params[:id])
    authorize booking
    booking.update(checked_in: true)
    redirect_to root_path, notice: 'Successfully checked in'
  end
end
