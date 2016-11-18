class AddBookingPriceToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :booking_price, :float, default: 0.0
  end
end
