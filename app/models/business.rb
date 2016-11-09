class Business < ApplicationRecord
  belongs_to :user
  has_many :activities

  has_attached_file :profile_picture,
    url: ':s3_domain_url',
    path: 'business/:id/:basename.:extension',
    storage: :s3,
    bucket: ENV['S3_BUCKET'],
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET'],
    },
    s3_protocol: "https",
    styles: {
      large: "500x500>",
      medium: "300x300>",
      thumb: "150x150#"
    }

  validates_attachment_content_type :profile_picture,
    content_type: /\Aimage\/.*\z/
  validates_presence_of :name, :address
  validates :phone_number, presence: true
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
