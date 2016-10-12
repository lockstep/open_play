class AddPreventBackToBackBookingToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :prevent_back_to_back_booking, :boolean, default: false
  end
end
