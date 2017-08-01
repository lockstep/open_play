module ActivitiesHelper
  def should_activate_edit_activity?(controller_name, action_name)
    'active' if controller_name == 'activities' &&
    (action_name == 'edit' || action_name == 'update')
  end

  def should_activate_closing_time_schedules?(controller_name, action_name)
    'active' if controller_name == 'closed_schedules' &&
    (action_name == 'index' || action_name == 'create')
  end

  def should_activate_rate_override_schedules?(controller_name, action_name)
    'active' if controller_name == 'rate_override_schedules' &&
    (action_name == 'index' || action_name == 'create')
  end

  def activity_unit(activity_type)
    activity_type == 'Bowling' ? 'round' : 'room'
  end
end
