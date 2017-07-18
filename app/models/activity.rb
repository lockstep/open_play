class Activity < ApplicationRecord
  include TimeValidations

  belongs_to :business
  has_many :reservables, dependent: :destroy
  has_many :orders
  has_many :closed_schedules, dependent: :destroy
  has_many :rate_override_schedules, dependent: :destroy

  validates :name, presence: true

  scope :active, -> { where(archived: false) }
  delegate :user, to: :business

  def self.types
    %w(bowling laser_tag)
  end

  def self.search(activity_type, location_params)
    lat = location_params[:latitude]
    lng = location_params[:longitude]
    if lat.present? && lng.present?
      businesses_ids = Business.find_nearest_business(lat, lng).map(&:id)
      Activity.where(business_id: businesses_ids, type: activity_type,
                     archived: false)
    else
      Activity.where(type: activity_type, archived: false)
    end
  end
end
