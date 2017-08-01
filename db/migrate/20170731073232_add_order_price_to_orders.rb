class AddOrderPriceToOrders < ActiveRecord::Migration[5.0]
  def change
    add_monetize :orders, :price
    add_monetize :orders, :open_play_fee
    add_monetize :orders, :stripe_fee
  end
end
