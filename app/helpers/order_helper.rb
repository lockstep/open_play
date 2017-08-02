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
    return '-' if booking_price.blank? || booking_price.zero?
    price = booking_price % 1 == 0 ? booking_price.to_i : "%.2f" % booking_price
    "$ #{price}"
  end

  def able_to_change_status?(action_name, booking)
    return false if booking.checked_in || booking.canceled
    action_name == 'reservations_for_business_owner'
  end

  def status(booking)
    return 'Checked in' if booking.checked_in
    return 'Canceled' if booking.canceled
    ''
  end
end
