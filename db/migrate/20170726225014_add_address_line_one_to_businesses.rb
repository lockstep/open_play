class AddAddressLineOneToBusinesses < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :address_line_one, :text
  end
end
