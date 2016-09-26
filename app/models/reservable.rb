class Reservable < ApplicationRecord
  belongs_to :activity
  has_many :options,
    foreign_key: 'reservable_type',
    primary_key: 'type',
    class_name: 'ReservableOption'
  has_many :options_availables, class_name: 'ReservableOptionsAvailable'

  validates :interval, numericality: { only_integer: true }
  validate :end_time_is_after_start_time

  after_initialize do |reservable|
    reservable.start_time = activity.start_time
    reservable.end_time = activity.end_time
  end

  scope :lanes, -> { where(type: 'Lane') }
  scope :rooms, -> { where(type: 'Room') }

  def end_time_is_after_start_time
    unless start_time < end_time
      errors.add(:end_time, 'must be after the start time')
    end
  end

end
