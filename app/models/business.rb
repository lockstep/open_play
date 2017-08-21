class Business < ApplicationRecord
  include PhoneValidations

  belongs_to :user
  has_many :activities

  has_attached_file :profile_picture,
    url: ':s3_domain_url',
    path: 'business/:id/:basename.:extension',
    default_url: 'avatar/:style/business-avatar.png',
    storage: :s3,
    bucket: ENV['S3_BUCKET'],
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET'],
    },
    s3_protocol: 'https',
    styles:  { medium: '300x300>', large: '600x600>' }

  validates_attachment_content_type :profile_picture,
    content_type: /\Aimage\/.*\z/
  validates_presence_of :name

  geocoded_by :geocoding_address

  scope :with_activity, -> (activity_type) {
    return if activity_type.blank?

    joins(:activities)
    .where('activities.type': activity_type)
    .group('businesses.id')
  }

  DEFAULT_SEARCH_RADIUS = 60 # Miles

  def self.find_nearest_business(lat, lng)
    Business.near([lat, lng], DEFAULT_SEARCH_RADIUS)
  end

  def address
    [address_line_one, city, state, zip, country]
      .compact.reject(&:empty?).join(', ')
  end

  def geocoding_address
    [address_line_one, city, state, country].compact.reject(&:empty?).join(', ')
  end
end
