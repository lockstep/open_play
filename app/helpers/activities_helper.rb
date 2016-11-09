module ActivitiesHelper
  def activate_edit_activity_sidebar_menu_if_action_is_matched(controller_name, action_name)
    'active' if controller_name == 'activities' &&
    (action_name == 'edit' || action_name == 'update')
  end

  def activate_closing_time_sidebar_menu_if_action_is_matched(controller_name, action_name)
    'active' if controller_name == 'closed_schedules' &&
    (action_name == 'index' || action_name == 'create')
  end
end
