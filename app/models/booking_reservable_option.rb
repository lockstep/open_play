class BookingReservableOption < ApplicationRecord
  belongs_to :booking, inverse_of: :reservable_options
  belongs_to :reservable_option

  delegate :name, to: :reservable_option, prefix: true
end
