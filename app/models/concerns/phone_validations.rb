module PhoneValidations
  extend ActiveSupport::Concern

  included do
    validates_presence_of :phone_number
    validate :phone_number_must_be_in_correct_format

    def phone_number_must_be_in_correct_format
      return unless phone_number.present?
      phone_number_regexp = Regexp.new([
                              '^\s*(?:\+?(\d{1,3}))?',
                              '[-. (]*(\d{3})',
                              '[-. )]*(\d{3})',
                              '[-. ]*(\d{4})(?: *x(\d+))?\s*$'].join)
      unless phone_number_regexp.match(phone_number)
        errors.add(:phone_number, 'This field contains some invalid characters')
      end
    end
  end
end
