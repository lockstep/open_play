class ClosedSchedule < ApplicationRecord
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
end
