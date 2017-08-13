class AddParentIdToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :parent_id, :integer
    add_index :bookings, %i[parent_id]
  end
end
