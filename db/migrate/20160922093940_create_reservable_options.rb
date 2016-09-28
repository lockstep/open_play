class CreateReservableOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :reservable_options do |t|
      t.string :reservable_type
      t.string :name

      t.timestamps
    end
  end
end
