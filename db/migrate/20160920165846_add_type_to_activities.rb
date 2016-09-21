class AddTypeToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :type, :string
  end
end
