class RateOverrideSchedule < ApplicationRecord
  include DateTimeUtilities

  belongs_to :activity

  validates_presence_of :label
  validate :at_least_one_day_is_selected
  validate :at_least_one_reservable_is_selected
  validate :overriding_ends_at_is_after_overriding_begins_at
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :per_person_price, numericality: { greater_than_or_equal_to: 0 }

  delegate :name, to: :activity, prefix: true
  delegate :user, to: :activity

  def at_least_one_day_is_selected
    return if overridden_specific_day
    errors.add(:overridden_days, 'must be selected') if overridden_days.blank?
  end

  def overriding_ends_at_is_after_overriding_begins_at
    return if overridden_all_day || (overriding_begins_at < overriding_ends_at)
    errors.add(:overriding_ends_at, "must be after #{display_time(overriding_begins_at)}")
  end

  def at_least_one_reservable_is_selected
    return if overridden_all_reservables
    errors.add(:overridden_reservables, 'must be selected') if overridden_reservables.blank?
  end
end
