class ReservableOptionsAvailable < ApplicationRecord
  belongs_to :reservable
  belongs_to :reservable_option
end
