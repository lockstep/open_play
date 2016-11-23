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

  def report_date_format(date)
    date.strftime("%e %B %Y")
  end

  def merge_date_and_time(date, time)
    date + time.seconds_since_midnight.seconds
  end

  def round_time(time, minutes, round_up=true)
    time_remainder = time.to_i % minutes
    return time if time_remainder == 0
    return time - time_remainder unless round_up
    time - time_remainder + minutes
  end

end
