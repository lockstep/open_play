class AddSessionLocationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :address, :string
    add_column :users, :session_latitude, :float
    add_column :users, :session_longitude, :float
    add_column :users, :session_address, :string
    add_column :users, :last_searched_at, :datetime
  end
end
