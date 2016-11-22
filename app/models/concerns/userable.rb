module Userable
  extend ActiveSupport::Concern

  included do
    validates_presence_of :first_name, :last_name

    def full_name
      "#{first_name} #{last_name}"
    end
  end
end
