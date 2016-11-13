module ClosedSchedulesHelper
  def shouldCheckDay(day_list, day)
    day_list.include?(day) ? true : false
  end

  def display_closed_every_x_day(day_list)
    "Every #{day_list.join(',')}"
  end

  def display_closed_on_days(schedule)
    if schedule.closed_specific_day
      present_date_in_day_month_year_format(schedule.closed_on)
    else
      display_closed_every_x_day(schedule.closed_days)
    end
  end

  def display_closed_time(schedule)
    return 'All day' if schedule.closed_all_day
    present_range_of_time(schedule.closing_begins_at, schedule.closing_ends_at)
  end
end
