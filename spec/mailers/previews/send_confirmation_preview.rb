# Preview all emails at http://localhost:3000/rails/mailers/send_confirmation
class SendConfirmationPreview < ActionMailer::Preview
  def booking_confirmation
    order = Order.first || create_order
    SendConfirmationMailer.booking_confirmation(order.id)
  end

  private

  def create_order
    user = User.first || User.create(email: 'test@example.com', password: 'password')
    business = Business.create(
      name: 'Johns Avenue',
      user: user
    )
    activity = Bowling.create(
      name: 'Country Club',
      start_time: '09:00',
      end_time: '17:00',
      business: business
    )
    lane = Lane.create(
      name: 'lane 1',
      start_time: '09:00:00',
      end_time: '17:00:00',
      interval: 60,
      activity: activity,
      maximum_players: 30,
      weekday_price: 5,
      weekend_price: 10
    )
    order = Order.create(user: user, activity: activity)
    booking = Booking.create(
      start_time: '09:00',
      end_time: '10:00',
      booking_date: '2001-02-03',
      number_of_players: 2,
      order: order,
      reservable: lane
    )
    order
  end
end
