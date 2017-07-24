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

  factory :business_with_bowling_activity, parent: :business do
    after(:create) do |business|
      create(:bowling, business: business)
    end
  end

  factory :business_with_laser_tag_activity, parent: :business do
    after(:create) do |business|
      create(:laser_tag, business: business)
    end
  end
end
