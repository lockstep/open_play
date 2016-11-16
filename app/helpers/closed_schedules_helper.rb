module ClosedSchedulesHelper
  def shouldCheck(list_of_things, thing)
    list_of_things.include?(thing) ? true : false
  end

  def display_closed_every_x_day(day_list)
    "Every #{day_list.join(', ')}"
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

  def display_closed_lane(schedule)
    return 'All reservables' if schedule.closed_all_reservables
    Reservable.list_reservable_names_by_ids(schedule.closed_reservables).join(', ')
  end
end
