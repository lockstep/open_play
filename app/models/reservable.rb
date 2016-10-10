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

  def build_time_slots(booking_date, booking_time)
    exact_time = DateTime.parse(booking_date) + Time.parse(booking_time)
      .seconds_since_midnight.seconds

    earlier = exact_time - interval.minutes
    earliest = earlier - interval.minutes
    later = exact_time + interval.minutes
    latest = later + interval.minutes
    time_slots = [
      time_on_each_slot(earliest),
      time_on_each_slot(earlier),
      time_on_each_slot(exact_time),
      time_on_each_slot(later),
      time_on_each_slot(latest)
    ]
  end

  private

  def time_on_each_slot(time)
    if valid_booking_time?(time)
      available_booking_time?(time) ? time : nil
    else
      return nil
    end
  end

  def valid_booking_time?(time)
    start_date_time = time.beginning_of_day + start_time.seconds_since_midnight.seconds
    end_date_time = time.beginning_of_day + end_time.seconds_since_midnight.seconds
    time >= start_date_time && time < end_date_time
  end

  def available_booking_time?(booking_time)
    bookings = self.bookings.where(booking_date: booking_time)
    if bookings.present?
      bookings.each do |booking|
        start_booking_time = booking_time.beginning_of_day + booking.start_time
          .seconds_since_midnight.seconds
        end_booking_time = booking_time.beginning_of_day + booking.end_time
          .seconds_since_midnight.seconds
        isBusy = (booking_time >= start_booking_time) && (booking_time < end_booking_time)
        return false if isBusy
      end
    else
      return true
    end
  end

end
