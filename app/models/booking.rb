class Booking < ApplicationRecord
  belongs_to :order, inverse_of: :bookings
  belongs_to :reservable
  validates_presence_of :order, :number_of_players
  validates_numericality_of :number_of_players, greater_than: 0, only_integer: true,
    :if => Proc.new{|object| object.errors.empty?}

  delegate :activity_name, to: :reservable, prefix: true
end
