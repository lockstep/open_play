module SearchHelper
  def reservables_per_page(activity, number_of_reservables_per_page)
    activity.reservables.active.order(:name).limit(number_of_reservables_per_page)
  end

  def remaining_reservables?(activity, number_of_reservables_per_page)
    activity.reservables.active.size > number_of_reservables_per_page
  end
end
