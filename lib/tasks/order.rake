namespace :order do
  desc "assign_activity_id"
  task update_order: :environment do
    Order.all.each do |order|
      bookings = order.bookings
      reservable = bookings.first.reservable
      order.update(activity_id: reservable.activity.id)
    end
  end

  desc "update_booking_price"
  task update_booking_price: :environment do
    Order.all.each do |order|
      order.set_bookings_total_price
      order.save
    end
  end
end
