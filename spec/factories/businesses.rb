FactoryGirl.define do
  factory :business do
    name 'Disneyland'
    description 'amazing amusement park'
    user { create(:user) }
  end
end
