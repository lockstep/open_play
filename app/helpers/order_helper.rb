module OrderHelper
  def number_of_booked_players(booking)
    booked_player_count =  booking.reservable_number_of_booked_players(
      booking.start_time,
      booking.end_time,
      booking.booking_date
    )
    "(#{booked_player_count}/#{maximum_players(booking.reservable)})"
  end

  def present_booking_price(booking_price)
    return '-' if booking_price.cents == 0
    humanized_money_with_symbol booking_price
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
