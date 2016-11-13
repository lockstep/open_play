class AddCheckedInToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :checked_in, :boolean, default: false
  end
end
