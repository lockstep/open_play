class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.time :start_time
      t.time :end_time
      t.date :booking_date
      t.integer :number_of_players
      t.string :options
      t.references :order, foreign_key: true
      t.references :reservable, foreign_key: true

      t.timestamps
    end
  end
end
