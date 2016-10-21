namespace :order do
  desc "assign_activity_id"
  task update_order: :environment do
    Order.all.each do |order|
      bookings = order.bookings
      reservable = bookings.first.reservable
      order.update(activity_id: reservable.activity.id)
    end
  end
end
