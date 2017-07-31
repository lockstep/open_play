FactoryGirl.define do
  factory :order do
    user { create(:user) }
    activity { create(:bowling) }
    price 100
    stripe_fee 1.50
    open_play_fee 1
  end
end
