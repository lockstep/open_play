class ReservableOption < ApplicationRecord
  def check_selected_reservable_options(reservable_id, reservable_option_id)
    ReservableOptionsAvailable.find_by(
      reservable_id: reservable_id,
      reservable_option_id: reservable_option_id
      ).present?
  end
end
