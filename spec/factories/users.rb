FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    first_name 'Tom'
    last_name 'Cruise'
    password 'password'
    phone_number '+1 650-253-0000'

    factory :user_with_location do
      address 'San Francisco, CA, USA'
      latitude 37.7749295
      longitude (-122.41941550000001)
    end
  end
end
