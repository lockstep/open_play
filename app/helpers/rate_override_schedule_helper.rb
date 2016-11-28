module RateOverrideScheduleHelper
  def display_rate_overridden_on_days(schedule)
    if schedule.overridden_specific_day
      present_date_in_day_month_year_format(schedule.overridden_on)
    else
      display_closed_every_x_day(schedule.overridden_days)
    end
  end

  def display_rate_overridden_time(schedule)
    return 'All day' if schedule.overridden_all_day
    present_range_of_time(schedule.overriding_begins_at, schedule.overriding_ends_at)
  end

  def display_rate_overridden_on_lane(schedule)
    return 'All reservables' if schedule.overridden_all_reservables
    Reservable.list_reservable_names_by_ids(schedule.overridden_reservables).join(', ')
  end
end
