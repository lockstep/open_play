class User < ApplicationRecord
  include Userable
  include PhoneValidations
  include LocationConcerns

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :business
  has_many :orders

  def update_session_location(location_params = {})
    update(
      session_address: location_params[:address],
      session_latitude: location_params[:latitude],
      session_longitude: location_params[:longitude],
      last_searched_at: Time.now
    )
  end

  def should_reset_session_location?
    last_searched_at && last_searched_at < 4.hours.ago
  end
end
