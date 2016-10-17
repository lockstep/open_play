class AddPricesToReservables < ActiveRecord::Migration[5.0]
  def change
    add_column :reservables, :weekday_price, :float
    add_column :reservables, :weekend_price, :float
  end
end
