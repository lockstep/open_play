FactoryGirl.define do
  factory :order do
    user { create(:user) }
    activity { create(:bowling) }
  end
end
