module DateTimeHelper
  def present_time(time)
    time.strftime("%I:%M %p")
  end

  def present_range_of_time(start_time, end_time)
    "#{present_time(start_time)} - #{present_time(end_time)}"
  end

  def present_date(date)
    date.strftime("%A, %B %e")
  end

  def merge_date_and_time(date, time)
    date + time.seconds_since_midnight.seconds
  end
end
