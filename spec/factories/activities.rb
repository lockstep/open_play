FactoryGirl.define do
  factory :activity do
    name "bowling"
    business { create(:business) }
  end
end
