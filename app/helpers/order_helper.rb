module OrderHelper
  def number_of_booked_players(booking)
    booked_player_count =  booking.reservable_number_of_booked_players(
      booking.start_time,
      booking.end_time,
      booking.booking_date
    )
    "(#{booked_player_count}/#{booking.maximum_players})"
  end

  def present_booking_price(booking_price)
    booking_price.zero? ? '-' : "$ #{booking_price}"
  end

  def display_checked_in?(action_name, checked_in)
    action_name == 'reservations_for_business_owner' && checked_in == false
  end
end
