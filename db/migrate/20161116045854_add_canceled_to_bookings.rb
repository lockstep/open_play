class AddCanceledToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :canceled, :boolean, default: false
  end
end
