class ClosedSchedule < ApplicationRecord
  include DateTimeUtilities

  belongs_to :activity

  delegate :user, to: :activity
  
  validates_presence_of :label
  validate :closing_ends_at_is_after_closing_begins_at
  validate :days_need_to_be_checked

  def closing_ends_at_is_after_closing_begins_at
    return if closed_all_day || (closing_begins_at < closing_ends_at)
    errors.add(:closing_ends_at, 'must be after the closing_begins_at')
  end

  def days_need_to_be_checked
    return if closed_specific_day
    errors.add(:closed_days, 'must be checked') if closed_days.blank?
  end

  def day_is_in_range_of_schedule?(day)
    closed_days.include?(day)
  end

  def checking_schedule_in_case_of_closed_all_day(booking_date)
    date = Date.parse(booking_date)
    return date == closed_on if closed_specific_day
    day_is_in_range_of_schedule?(get_small_case_day_from_date(date))
  end

  def checking_schedule_in_case_of_closed_on_specific_day(booking_date, booking_time, interval_time)
    if closed_specific_day
      return false if Date.parse(booking_date) != closed_on
      check_overlap_time( booking_date, booking_time, interval_time, closing_begins_at, closing_ends_at)
    else
      date = Date.parse(booking_date)
      return false unless day_is_in_range_of_schedule?(get_small_case_day_from_date(date))
      check_overlap_time( booking_date, booking_time, interval_time, closing_begins_at, closing_ends_at)
    end
  end

  def match?(booking_date, booking_time, interval_time)
    return checking_schedule_in_case_of_closed_all_day(booking_date) if closed_all_day
    checking_schedule_in_case_of_closed_on_specific_day(booking_date, booking_time, interval_time)
  end
end
