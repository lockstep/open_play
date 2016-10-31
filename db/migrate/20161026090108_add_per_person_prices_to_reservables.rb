class AddPerPersonPricesToReservables < ActiveRecord::Migration[5.0]
  def change
    add_column :reservables, :per_person_weekday_price, :float, default: 0.0
    add_column :reservables, :per_person_weekend_price, :float, default: 0.0
  end
end
