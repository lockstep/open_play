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

    def allocate_reservables(number_of_players)
      allocated_reservable = {}
      total_required_reservables =
        (number_of_players.to_f / maximum_players_per_sub_reservable).ceil
      remain_players = number_of_players
      reservables =
        children.order(:priority_number).take(total_required_reservables)
      reservables.each do |reservable|
        if remain_players / maximum_players_per_sub_reservable >= 1
          allocated_count = maximum_players_per_sub_reservable
          remain_players -= maximum_players_per_sub_reservable
        else
          allocated_count = remain_players % maximum_players_per_sub_reservable
        end
        allocated_reservable[reservable.sub_reservable_id.to_s] = allocated_count
      end
      allocated_reservable
    end

    def sub_reservables_type
      activity.reservables.first.type
    end
  end
end
