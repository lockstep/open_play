class Reservable < ApplicationRecord
  belongs_to :activity
  has_many :options,
    foreign_key: 'reservable_type',
    primary_key: 'type',
    class_name: 'ReservableOption'
  has_many :options_availables, class_name: 'ReservableOptionsAvailable'
  has_many :bookings

  validates :interval, numericality: { only_integer: true }
  validate :end_time_is_after_start_time

  delegate :name, to: :activity, prefix: true

  def end_time_is_after_start_time
    return unless start_time.present? && end_time.present?
    unless start_time < end_time
      errors.add(:end_time, 'must be after the start time')
    end
  end

end
