module DateTimeUtilities
  def convert_date_to_date_time_in_seconds(date, time)
    date_time = date.to_datetime
    time_in_seconds = time.to_time.seconds_since_midnight.seconds
    date_time + time_in_seconds
  end

  def check_overlap_time(date, time, interval_time, begins_at, ends_at)
    start_date_x = convert_date_to_date_time_in_seconds(date, time)
    start_date_y = convert_date_to_date_time_in_seconds(date, begins_at)
    end_date_y = convert_date_to_date_time_in_seconds(date, ends_at)
    end_date_x = interval_time.nil? ? nil : start_date_x + interval_time.minutes
    overlap?(start_date_x, end_date_x, start_date_y, end_date_y)
  end

  def get_small_case_day_from_date(date)
    date.strftime('%A').downcase
  end

  def overlap?(start_date_x, end_date_x, start_date_y, end_date_y)
    if end_date_x.nil?
      start_date_x >= start_date_y and start_date_x < end_date_y
    else
      if start_date_x > start_date_y
        start_date_x, start_date_y = start_date_y, start_date_x
        end_date_x, end_date_y = end_date_y, end_date_x
      end
      start_date_x <= end_date_y and start_date_y < end_date_x
    end
  end
end
