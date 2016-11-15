module DateTimeHelper
  def present_time(time)
    time.strftime("%I:%M %p")
  end

  def present_range_of_time(start_time, end_time)
    "#{present_time(start_time)} - #{present_time(end_time)}"
  end

  def present_date_in_weekday_month_day_format(date)
    date.strftime("%A, %B %e")
  end

  def present_date_in_day_month_format(date)
    date.strftime("%e %B")
  end

  def present_date_in_day_month_year_format(date)
    date.strftime("%e %b %Y")
  end

  def merge_date_and_time(date, time)
    date + time.seconds_since_midnight.seconds
  end

  def round_up_time(time, minutes)
    time_remainder = time.to_i % minutes
    return time if time_remainder == 0
    time - time_remainder + minutes
  end

  def round_down_time(time, minutes)
    time_remainder = time.to_i % minutes
    return time if time_remainder == 0
    time - time_remainder
  end

end
