module TimeSlotsHelper
  def build_time_slots(reservable, booking_date, booking_time)
    booking_date = DateTime.parse(booking_date)
    requested_time = booking_date + Time.parse(booking_time)
      .seconds_since_midnight.seconds
    closing_time = merge_date_and_time(booking_date, reservable.end_time)
    time_slots = []
    subsequent_time = requested_time
    while subsequent_time < closing_time do
      time_slots.push(
        {
          time: subsequent_time,
          available: available_booking_time?(reservable, subsequent_time)
        }
      )
      subsequent_time += reservable.interval.minutes
    end
    time_slots
  end

  private

  def available_booking_time?(reservable, time)
    booking_date = time.beginning_of_day
    opening_time = merge_date_and_time(booking_date, reservable.start_time)
    closing_time = merge_date_and_time(booking_date, reservable.end_time)
    return false unless time >= opening_time && time < closing_time
    bookings = reservable.bookings.where(booking_date: time)
    return true unless bookings.present?
    bookings.each do |booking|
      start_booking_time = merge_date_and_time(booking_date, booking.start_time)
      end_booking_time = merge_date_and_time(booking_date, booking.end_time)
      return false unless (time < start_booking_time) || (time >= end_booking_time)
    end
    return true
  end

  def merge_date_and_time(date, time)
    date + time.seconds_since_midnight.seconds
  end
end
