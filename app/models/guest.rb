class Guest < ApplicationRecord
  include PhoneValidations

  validates_presence_of :first_name, :last_name, :email
  validates :email,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def full_name
    "#{first_name} #{last_name}"
  end
end
