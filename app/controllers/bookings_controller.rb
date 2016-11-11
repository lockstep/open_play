class BookingsController < ApplicationController
  before_action :authenticate_user!

  def checked_in
    booking = Booking.find(params[:id])
    authorize booking
    booking.update_attribute(:checked_in, true)
    redirect_to business_owner_reservations_path(booking.reservable_activity)
  end
end
