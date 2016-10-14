module TimeSlotsHelper
  include DateTimeHelper

  def build_time_slots(reservable, requested_date, requested_time)
    requested_date = DateTime.parse(requested_date)
    requested_time = requested_date + Time.parse(requested_time)
      .seconds_since_midnight.seconds
    closing_time = merge_date_and_time(requested_date, reservable.end_time)
    time_slots = []
    subsequent_time = requested_time
    while subsequent_time < closing_time do
      time_slots.push(
        {
          time: subsequent_time,
          available: reservable_available_to_book?(reservable, subsequent_time)
        }
      )
      subsequent_time += reservable.interval.minutes
    end
    time_slots
  end

  private

  def reservable_available_to_book?(reservable, requested_time)
    return false unless reservable_is_open?(reservable, requested_time)
    requested_date = requested_time.beginning_of_day
    bookings = reservable.bookings.where(booking_date: requested_time)
    return true unless bookings.present?
    bookings.each do |booking|
      start_booking_time = merge_date_and_time(requested_date, booking.start_time)
      end_booking_time = merge_date_and_time(requested_date, booking.end_time)
      availableToBook = (requested_time < start_booking_time) || (requested_time >= end_booking_time)
      return false unless availableToBook
    end
    true
  end

  def reservable_is_open?(reservable, requested_time)
    requested_date = requested_time.beginning_of_day
    opening_time = merge_date_and_time(requested_date, reservable.start_time)
    closing_time = merge_date_and_time(requested_date, reservable.end_time)
    inWorkingHours = (requested_time >= opening_time) && (requested_time < closing_time)
  end
end
