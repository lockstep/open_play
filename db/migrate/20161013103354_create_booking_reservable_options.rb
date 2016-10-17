class CreateBookingReservableOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :booking_reservable_options do |t|
      t.references :booking, foreign_key: true
      t.references :reservable_option, foreign_key: true

      t.timestamps
    end
  end
end
