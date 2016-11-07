module TimeSlotsHelper
  include DateTimeHelper

  def build_time_slots(reservable, requested_date)
    time_slots = []
    requested_date = DateTime.parse(requested_date)
    closing_time = merge_date_and_time(requested_date, reservable.closing_time)
    subsequent_time = merge_date_and_time(requested_date, reservable.opening_time)
    while subsequent_time < closing_time do
      time_slots.push(
        {
          time: subsequent_time,
          booking_info: booking_info(reservable, subsequent_time)
        }
      )
      subsequent_time += reservable.interval.minutes
    end
    time_slots
  end

  def booked_by_current_user(slot)
    if current_user && (current_user.id == slot[:booking_info][:booked_by])
      return 'current-user-booked-slot'
    else
      ''
    end
  end

  def requested_time_slot_index(reservable, requested_date, requested_time)
    requested_date = DateTime.parse(requested_date)
    if requested_time.present?
      requested_time = requested_date + Time.parse(requested_time)
        .seconds_since_midnight.seconds
    else
      requested_time = merge_date_and_time(requested_date, reservable.opening_time)
    end
    opening_time = merge_date_and_time(requested_date, reservable.opening_time)
    time_since_opening_in_mins = (requested_time - opening_time) * 24 * 60
    (time_since_opening_in_mins / reservable.interval).to_i
  end

  private

  def booking_info(reservable, requested_time)
    return { available: false } unless reservable_is_open?(reservable,requested_time)
    requested_date = requested_time.beginning_of_day
    bookings = reservable.bookings.where(booking_date: requested_date)
    return { available: true } unless bookings.present?
    bookings.each do |booking|
      start_booking_time = merge_date_and_time(requested_date, booking.start_time)
      end_booking_time = merge_date_and_time(requested_date, booking.end_time)
      time_was_booked = (requested_time >= start_booking_time) &&
        (requested_time < end_booking_time)
      if time_was_booked
        unless reservable_available_for_multi_party?(reservable,booking, requested_date)
          return { available: false, booked_by: booking.user_id }
        end
        return { available: true, booked_by: booking.user_id }
      end
    end
    return { available: true }
  end

  def reservable_available_for_multi_party?(reservable, booking, requested_date)
    reservable.allow_multi_party_bookings &&
      reservable.available_players(
        booking.start_time,
        booking.end_time,
        requested_date
      ) > 0
  end

  def reservable_is_open?(reservable, requested_time)
    requested_date = requested_time.beginning_of_day
    opening_time = merge_date_and_time(requested_date, reservable.opening_time)
    closing_time = merge_date_and_time(requested_date, reservable.closing_time)
    inWorkingHours = (requested_time >= opening_time) &&
      (requested_time < closing_time)
  end
end
