module SearchHelper
  def first_set_of_reservables(reservables)
    reservables.active.order(:name).page(1).per(5)
  end
end
