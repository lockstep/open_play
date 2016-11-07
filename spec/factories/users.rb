FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    first_name 'Tom'
    last_name 'Cruise'
    password 'password'  
  end
end
