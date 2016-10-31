class AddDefaultPricesToReservabels < ActiveRecord::Migration[5.0]
  def change
    change_column :reservables, :weekday_price, :float, default: 0.0
    change_column :reservables, :weekend_price, :float, default: 0.0
  end
end
