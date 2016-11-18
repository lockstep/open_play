class AddPaidExternallyToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :paid_externally, :boolean, default: false
  end
end
