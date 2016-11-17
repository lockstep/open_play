module DateTimeUtilities
  def convert_date_to_date_time_in_seconds(date, time)
    date_time = date.to_datetime
    time_in_seconds = time.to_time.seconds_since_midnight.seconds
    date_time + time_in_seconds
  end

  def check_overlap_time(date, time, interval_time, begins_at, ends_at)
    start_date_x = convert_date_to_date_time_in_seconds(date, time)
    start_date_y = convert_date_to_date_time_in_seconds(date, begins_at)
    end_date_x = start_date_x + interval_time.minutes
    end_date_y = convert_date_to_date_time_in_seconds(date, ends_at)
    overlap?(start_date_x, end_date_x, start_date_y, end_date_y)
  end

  def overlap?(start_date_x, end_date_x, start_date_y, end_date_y)
    if start_date_x > start_date_y
      start_date_x, start_date_y = start_date_y, start_date_x
      end_date_x, end_date_y = end_date_y, end_date_x
    end
    start_date_x <= end_date_y and start_date_y < end_date_x
  end

  def display_day(date)
    date.strftime('%A')
  end

  def display_time(time)
    time.strftime("%I:%M %p")
  end

  def present_date_in_day_month_year_format(date)
    date.strftime("%e %b %Y")
  end
end
