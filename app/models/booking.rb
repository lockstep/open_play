class Booking < ApplicationRecord
  belongs_to :order, inverse_of: :bookings
  belongs_to :reservable

  validates_presence_of :order, :number_of_players
  validates_numericality_of :number_of_players, only_integer: true,
    greater_than: 0, if: Proc.new{ |object| object.errors.empty? }
  validate :number_of_players_cannot_over_than_available_players,
    :if => Proc.new{ |object| object.reservable_is_a_room? && object.errors.empty? }

  delegate :activity_name, to: :reservable, prefix: true
  delegate :name, to: :reservable, prefix: true
  delegate :is_a_room?, to: :reservable, prefix: true
  delegate :maximum_players, to: :reservable

  scope :on_date_time, -> (start_time, end_time, date) {
    where(start_time: start_time, end_time: end_time, booking_date: date)
  }

  def number_of_booked_players(start_time, end_time, booking_date)
    reservable.number_of_booked_players(start_time, end_time, booking_date) if reservable_is_a_room?
  end

  def number_of_players_cannot_over_than_available_players
    if number_of_players > reservable.available_players(start_time, end_time, booking_date)
      errors.add(:number_of_players, 'must be less than available players')
    end
  end
end
