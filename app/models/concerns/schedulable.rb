module Schedulable
  extend ActiveSupport::Concern
  include DateTimeUtilities

  included do

    def day_is_in_range_of_schedule?(days, day)
      days.include?(day)
    end

    def checking_all_day_schedule(date, scheduled_on, scheduled_specific_day, scheduled_days)
      booking_date = Date.parse(date)
      return booking_date == scheduled_on if scheduled_specific_day
      day_is_in_range_of_schedule?(scheduled_days, display_day(booking_date))
    end

    def checking_specific_day_schedule(booking_date, booking_time, interval_time, scheduled_on, scheduled_specific_day, scheduling_begin_at, scheduling_ends_at, scheduled_days)
      if scheduled_specific_day
        return false if Date.parse(booking_date) != scheduled_on
        check_overlap_time( booking_date, booking_time, interval_time, scheduling_begin_at, scheduling_ends_at)
      else
        date = Date.parse(booking_date)
        return false unless day_is_in_range_of_schedule?(scheduled_days, display_day(date))
        check_overlap_time( booking_date, booking_time, interval_time, scheduling_begin_at, scheduling_ends_at)
      end
    end
  end
end
