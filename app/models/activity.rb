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

  def self.search(booking_date, booking_time, activity_type)
    Activity.active.where("type = ?", activity_type)
  end
end
