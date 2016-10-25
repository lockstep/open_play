class AddPhoneAndAddressToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :phone_number, :string
    add_column :businesses, :address, :string
    add_attachment :businesses, :profile_picture
  end
end
