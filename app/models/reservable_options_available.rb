class ReservableOptionsAvailable < ApplicationRecord
  belongs_to :reservable
  belongs_to :reservable_option

  delegate :id, to: :reservable_option, prefix: true
  delegate :name, to: :reservable_option, prefix: true
end
