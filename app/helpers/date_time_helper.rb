module DateTimeHelper
  def present_time(time)
    time.localtime.strftime("%I:%M %p")
  end

  def present_range_of_time(start_time, end_time)
    "#{present_time(start_time)} - #{present_time(end_time)}"
  end

  def present_date(date)
    date.strftime("%A, %B %e")
  end
end
