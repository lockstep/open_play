module TimeValidations
  extend ActiveSupport::Concern

  included do
    validates_presence_of :start_time, :end_time
    validate :end_time_is_after_start_time

    def end_time_is_after_start_time
      return unless start_time.present? && end_time.present?
      return unless start_time > end_time
      errors.add(:end_time, 'must be after the start time')
    end
  end
end
