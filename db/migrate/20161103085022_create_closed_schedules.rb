class CreateClosedSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :closed_schedules do |t|
      t.string :label
      t.date :closed_on
      t.string :closed_days, array: true, default: []
      t.boolean :closed_all_day
      t.boolean :closed_specific_day
      t.time :closing_begins_at
      t.time :closing_ends_at
      t.references :activity, foreign_key: true
    end
  end
end
