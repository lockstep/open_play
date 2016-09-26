class CreateReservableOptionsAvailables < ActiveRecord::Migration[5.0]
  def change
    create_table :reservable_options_availables do |t|
      t.references :reservable, foreign_key: true
      t.references :reservable_option, foreign_key: true

      t.timestamps
    end
  end
end
