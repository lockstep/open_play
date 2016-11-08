module DateTimeUtilities
  def convert_date_to_date_time_in_seconds(date, time)
    date_time = date.to_datetime
    time_in_seconds = time.to_time.seconds_since_midnight.seconds
    date_time + time_in_seconds
  end

  def checking_date_time_is_in_range_of_begins_and_end(date, time, begins_at, ends_at)
    date_time = convert_date_to_date_time_in_seconds(date, time)
    begins_at_date_time = convert_date_to_date_time_in_seconds(date, begins_at)
    ends_at_date_time = convert_date_to_date_time_in_seconds(date, ends_at)
    date_time >= begins_at_date_time && date_time < ends_at_date_time
  end

  def get_small_case_day_from_date(date)
    date.strftime('%A').downcase
  end
end
