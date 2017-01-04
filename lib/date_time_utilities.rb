module DateTimeUtilities
  def convert_date_to_date_time_in_seconds(date, time)
    date_time = date.to_datetime
    time_in_seconds = time.to_time.seconds_since_midnight.seconds
    date_time + time_in_seconds
  end

  def check_overlap_time(date, time, interval_time, begins_at, ends_at)
    first_start_date = convert_date_to_date_time_in_seconds(date, time)
    second_start_date = convert_date_to_date_time_in_seconds(date, begins_at)
    first_end_date = first_start_date + interval_time.minutes
    second_end_date = convert_date_to_date_time_in_seconds(date, ends_at)
    overlap?(first_start_date, first_end_date, second_start_date, second_end_date)
  end

  def overlap?(first_start_date, first_end_date, second_start_date, second_end_date)
    if first_start_date > second_start_date
      first_start_date, second_start_date = second_start_date, first_start_date
      first_end_date, second_end_date = second_end_date, first_end_date
    end
    first_start_date <= second_end_date and second_start_date < first_end_date
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

  def time_diff_in_minutes(start_time, end_time)
    (end_time.seconds_since_midnight - start_time.seconds_since_midnight) / 60
  end
end
