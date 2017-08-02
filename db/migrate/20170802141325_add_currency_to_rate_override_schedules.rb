class AddCurrencyToRateOverrideSchedules < ActiveRecord::Migration[5.0]
  def change
    remove_column :rate_override_schedules, :price, :float, default: 0
    remove_column :rate_override_schedules, :per_person_price, :float, default: 0
    add_monetize :rate_override_schedules, :price
    add_monetize :rate_override_schedules, :per_person_price
  end
end
