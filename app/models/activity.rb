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
