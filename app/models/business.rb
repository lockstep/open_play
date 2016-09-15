class Business < ApplicationRecord
  belongs_to :user
  has_many :activities
  validates_presence_of :name
end
