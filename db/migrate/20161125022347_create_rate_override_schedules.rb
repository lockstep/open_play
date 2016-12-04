class CreateRateOverrideSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :rate_override_schedules do |t|
      t.string :label
      t.date :overridden_on
      t.string :overridden_days, array: true, default: []
      t.boolean :overridden_all_day
      t.boolean :overridden_specific_day
      t.time :overriding_begins_at
      t.time :overriding_ends_at
      t.boolean :overridden_all_reservables, default: true
      t.integer :overridden_reservables, array: true, default: []
      t.float :price, default: 0.0
      t.float :per_person_price, default: 0.0
      t.references :activity, foreign_key: true
    end
  end
end
