class AddCurrencySupportToReservables < ActiveRecord::Migration[5.0]
  def change
    remove_column :reservables, :weekday_price, :float, default: 0
    remove_column :reservables, :weekend_price, :float, default: 0
    remove_column :reservables, :per_person_weekday_price, :float, default: 0
    remove_column :reservables, :per_person_weekend_price, :float, default: 0
    add_monetize :reservables, :weekday_price
    add_monetize :reservables, :weekend_price
    add_monetize :reservables, :per_person_weekday_price
    add_monetize :reservables, :per_person_weekend_price
  end
end
