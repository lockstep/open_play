module OrdersHelper
  def present_time_as_meridiem_notation(time)
    time.localtime.strftime("%I:%M %p")
  end

  def present_range_of_time(start_time, end_time)
    "#{present_time_as_meridiem_notation(start_time)} - #{present_time_as_meridiem_notation(end_time)}"
  end

  def present_date(date)
    date.strftime("%A, %B %e")
  end
end
