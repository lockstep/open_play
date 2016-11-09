module ClosedSchedulesHelper
  def shouldCheckDay(day_list, day)
    day_list.include?(day) ? true : false
  end
end
