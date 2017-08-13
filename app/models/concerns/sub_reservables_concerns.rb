module SubReservablesConcerns
  extend ActiveSupport::Concern

  included do
    has_many :children,
             class_name: 'ReservableSubReservable',
             foreign_key: 'parent_reservable_id'
    has_many :sub_reservables,
             through: :children,
             class_name: 'Reservable'

    def validate_sub_reservables(params)
      return true if !party_room? || params[:sub_reservables].present?
      errors.add(:sub_reservables, 'must be choosen at least one')
      false
    end

    def assign_sub_reservables(params)
      return unless party_room?
      params[:sub_reservables].each do |_key, sub_reservable|
        children << ReservableSubReservable.new(
          parent_reservable_id: id,
          sub_reservable_id: sub_reservable[:id],
          priority_number: sub_reservable[:priority_number]
        )
      end
    end
  end
end
