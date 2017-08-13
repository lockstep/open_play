class ReservableSubReservable < ApplicationRecord
  belongs_to :parent_reservable, class_name: 'Reservable'
  belongs_to :sub_reservable, class_name: 'Reservable'
end
