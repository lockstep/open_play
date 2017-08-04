class CreateReservableSubReservables < ActiveRecord::Migration[5.0]
  def change
    create_table :reservable_sub_reservables do |t|
      t.integer :parent_reservable_id
      t.integer :sub_reservable_id
      t.integer :priority_number
    end

    add_index :reservable_sub_reservables, %i[parent_reservable_id]
  end
end
