class AddOrderPriceToOrders < ActiveRecord::Migration[5.0]
  def change
    add_monetize :orders, :price, currency: { present: false }
    add_monetize :orders, :open_play_fee, currency: { present: false }
    add_monetize :orders, :stripe_fee, currency: { present: false }
  end
end
