class RemoveIsOwnerFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :is_owner, :boolean
  end
end
