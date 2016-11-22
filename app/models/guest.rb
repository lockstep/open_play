class Guest < ApplicationRecord
  include Userable
  include PhoneValidations

  validates_presence_of :email
  validates :email,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
