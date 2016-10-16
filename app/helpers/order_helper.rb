module OrderHelper
  def number_of_booked_players(booking)
    booked_player_count =  booking.reservable_number_of_booked_players(
      booking.start_time,
      booking.end_time,
      booking.booking_date
    )
    "(#{booked_player_count}/#{booking.maximum_players})"
  end
end