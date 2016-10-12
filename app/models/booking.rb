class Booking < ApplicationRecord
  belongs_to :order, inverse_of: :bookings
  belongs_to :reservable

  validates_presence_of :order, :number_of_players
  validates_numericality_of :number_of_players, only_integer: true,
    greater_than: 0, if: Proc.new{ |object| object.errors.empty? }
  validate :number_of_players_cannot_exceed_maximum

  delegate :activity_name, to: :reservable, prefix: true
  delegate :name, to: :reservable, prefix: true
  delegate :maximum_players, to: :reservable
  delegate :number_of_booked_players, to: :reservable, prefix: true

  scope :during, -> (start_time, end_time, date) {
    where(start_time: start_time, end_time: end_time, booking_date: date)
  }

  def number_of_players_cannot_exceed_maximum
    if errors.empty? && number_of_players >
      reservable.available_players(start_time, end_time, booking_date)
      errors.add(:number_of_players, 'must be fewer than available players')
    end
  end
end
