class AddActivityReferenceToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :activity, foreign_key: true
  end
end
