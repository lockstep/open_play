class AddClosedAllReservablesToClosedSchedules < ActiveRecord::Migration[5.0]
  def change
    add_column :closed_schedules, :closed_all_reservables, :boolean, default: true
    add_column :closed_schedules, :closed_reservables, :integer, array: true, default: []
    change_column :closed_schedules, :closed_all_day, :boolean, :default => true
    change_column :closed_schedules, :closed_specific_day, :boolean, :default => true
  end
end
