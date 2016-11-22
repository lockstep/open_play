FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    first_name 'Tom'
    last_name 'Cruise'
    password 'password'
    phone_number '+1 650-253-0000'
  end
end
