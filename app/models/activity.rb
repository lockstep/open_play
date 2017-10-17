class Activity < ApplicationRecord
  include TimeValidations
  IMAGE_FORMATS = ['image/jpeg', 'image/jpg', 'image/png'].freeze

  belongs_to :business
  has_many :reservables, dependent: :destroy
  has_many :orders
  has_many :closed_schedules, dependent: :destroy
  has_many :rate_override_schedules, dependent: :destroy
  has_many :party_rooms, foreign_key: 'activity_id'

  has_attached_file :picture,
    url: ':s3_domain_url',
    path: 'activity/:id/:basename.:extension',
    default_url: 'avatar/:style/activity-avatar.png',
    storage: :s3,
    bucket: ENV['S3_BUCKET'],
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET'],
    },
    s3_protocol: 'https',
    styles:  { medium: ['300x300>'], larger: '600x600#' }

  validates_attachment_content_type :picture, content_type: IMAGE_FORMATS,
    message: 'Uploaded file is not a valid image. Only JPG, JPEG and PNG files'\
             ' are allowed'
  validates :name, presence: true

  scope :active, -> { where(archived: false) }
  scope :by_type, ->(type) { where(type: type).active }
  scope :by_business, lambda { |business_id|
    where(business_id: business_id).active
  }
  scope :by_location, lambda { |lat, lng|
    return all if lat.blank? || lng.blank?
    where(business_id: Business.find_nearest_business(lat, lng).map(&:id))
  }
  scope :available_on_date, lambda { |date|
    days_from_now = (Date.parse(date) - Date.current).to_i
    where('lead_time <= ?', days_from_now)
  }

  delegate :user, to: :business
  delegate :id, to: :business, prefix: true

  def self.types
    %w(bowling laser_tag escape_room)
  end

  def self.search_by_type_within_area(query)
    by_type(query[:activity_type])
      .available_on_date(query[:date])
      .by_location(query[:latitude], query[:longitude])
  end

  def self.search_by_business(business_id, date)
    by_business(business_id)
      .available_on_date(date)
  end

  def build_reservable(type)
    reservable = case type
                 when 'Lane'
                   lanes.new
                 when 'Room'
                   rooms.new
                 when 'PartyRoom'
                   party_rooms.new
                 end
    reservable.start_time = start_time
    reservable.end_time = end_time
    reservable
  end
end
