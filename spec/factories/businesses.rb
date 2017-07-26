FactoryGirl.define do
  factory :business do
    name 'Disneyland'
    address_line_one '123 building'
    phone_number 1234567890
    latitude 37.7749295
    longitude (-122.41941550)
    city 'San Francisco'
    state 'CA'
    zip '94107'
    country 'USA'
    description 'amazing amusement park'
    user { create(:user) }
  end
end
