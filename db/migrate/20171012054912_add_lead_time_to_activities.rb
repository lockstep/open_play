class AddLeadTimeToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :lead_time, :integer, default: 0
  end
end
