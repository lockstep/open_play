class Booking < ApplicationRecord
  belongs_to :order, inverse_of: :bookings
  belongs_to :reservable

  validates_presence_of :order, :number_of_players
  validates_numericality_of :number_of_players, only_integer: true,
    greater_than: 0, if: Proc.new{ |object| is_belongs_to_a_room_with_no_errors?(object)}
  validate :number_of_players_cannot_over_than_available_players,
    :if => Proc.new{ |object| is_belongs_to_a_room_with_no_errors?(object) }

  delegate :activity_name, to: :reservable, prefix: true
  delegate :name, to: :reservable, prefix: true
  delegate :number_of_booked_players, to: :reservable
  delegate :maximum_players, to: :reservable

  def is_belongs_to_a_room_with_no_errors?(object)
    object.reservable.is_a_room? && object.errors.empty?
  end

  def number_of_players_cannot_over_than_available_players
    if number_of_players > reservable.available_players
      errors.add(:number_of_players, 'must be less than available players')
    end
  end
end
