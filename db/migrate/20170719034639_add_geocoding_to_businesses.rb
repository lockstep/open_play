class AddGeocodingToBusinesses < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :latitude, :float
    add_column :businesses, :longitude, :float
    add_column :businesses, :country, :string
    add_column :businesses, :city, :string
    add_column :businesses, :state, :string
    add_column :businesses, :zip, :string
  end
end
