namespace :booking do
  desc "update_booking_price"
  task update_booking_price: :environment do
    Booking.all.each(&:update_total_price)
  end
end
