class Activity < ApplicationRecord
  include TimeValidations
  IMAGE_FORMATS = ['image/jpeg', 'image/jpg', 'image/png'].freeze

  belongs_to :business
  has_many :reservables, dependent: :destroy
  has_many :orders
  has_many :closed_schedules, dependent: :destroy
  has_many :rate_override_schedules, dependent: :destroy

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
  delegate :user, to: :business
  delegate :id, to: :business, prefix: true

  def self.types
    %w(bowling laser_tag escape_room)
  end

  def self.search(params)
    lat = params[:latitude]
    lng = params[:longitude]
    if lat.present? && lng.present?
      businesses_ids = Business.find_nearest_business(lat, lng).map(&:id)
      Activity.where(business_id: businesses_ids, type: params[:activity_type],
                     archived: false)
    else
      Activity.where(type: params[:activity_type], archived: false)
    end
  end
end
