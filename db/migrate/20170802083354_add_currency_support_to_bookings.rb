class AddCurrencySupportToBookings < ActiveRecord::Migration[5.0]
  def change
    remove_column :bookings, :booking_price, :float, default: 0
    add_monetize :bookings, :booking_price
  end
end
