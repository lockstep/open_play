class CreateReservables < ActiveRecord::Migration[5.0]
  def change
    create_table :reservables do |t|
      t.string :name
      t.string :type
      t.integer :interval
      t.time :start_time
      t.time :end_time
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
