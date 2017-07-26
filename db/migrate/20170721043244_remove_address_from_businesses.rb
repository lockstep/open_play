class RemoveAddressFromBusinesses < ActiveRecord::Migration[5.0]
  def change
    remove_column :businesses, :address, :string
  end
end
