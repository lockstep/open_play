class AddOrderPriceToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :price, :float, default: 0.0
    add_column :orders, :open_play_fee, :float, default: 0.0
    add_column :orders, :stripe_fee, :float, default: 0.0
  end
end
