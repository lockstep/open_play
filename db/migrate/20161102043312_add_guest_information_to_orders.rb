class AddGuestInformationToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :guest_first_name, :string, default: ''
    add_column :orders, :guest_last_name, :string, default: ''
    add_column :orders, :guest_email, :string, default: ''
  end
end
