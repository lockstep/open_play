class AddGuestToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :guest, foreign_key: true
  end
end
