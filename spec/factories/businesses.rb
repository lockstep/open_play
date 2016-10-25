FactoryGirl.define do
  factory :business do
    name 'Disneyland'
    phone_number 1234567890
    address '123 building'
    description 'amazing amusement park'
    user { create(:user) }
  end
end
