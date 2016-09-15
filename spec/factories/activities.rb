FactoryGirl.define do
  factory :activity do
    name "bowling"
    start_time '09:00:00'
    end_time '17:00:00'
    business { create(:business) }
  end
end
