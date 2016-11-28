class ClosedSchedule < ApplicationRecord
  include Schedulable

  belongs_to :activity

  delegate :user, to: :activity
  delegate :name, to: :activity, prefix: true

  validates_presence_of :label
  validate :closing_ends_at_is_after_closing_begins_at
  validate :at_least_one_day_is_selected
  validate :at_least_one_reservable_is_selected

  scope :find_by_activity_or_reservable, -> (reservable) {
    where("(closed_all_reservables = true AND activity_id = ?)
      OR closed_reservables @> ?", reservable.activity_id, "{#{reservable.id}}")
  }

  def closing_ends_at_is_after_closing_begins_at
    return if closed_all_day || (closing_begins_at < closing_ends_at)
    errors.add(:closing_ends_at, "must be after #{display_time(closing_begins_at)}")
  end

  def at_least_one_day_is_selected
    return if closed_specific_day
    errors.add(:closed_days, 'must be selected') if closed_days.blank?
  end

  def at_least_one_reservable_is_selected
    return if closed_all_reservables
    errors.add(:closed_reservables, 'must be selected') if closed_reservables.blank?
  end

  def match?(booking_date, booking_time, interval_time)
    return checking_all_day_schedule(
      booking_date, closed_on, closed_specific_day, closed_days
    ) if closed_all_day
    checking_specific_day_schedule(
      booking_date, booking_time, interval_time,
      closed_on, closed_specific_day, closing_begins_at,
      closing_ends_at, closed_days
    )
  end
end
