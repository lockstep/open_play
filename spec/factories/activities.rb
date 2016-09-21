FactoryGirl.define do
  factory :activity do
    name "Country Club Lanes"
    start_time '09:00:00'
    end_time '17:00:00'
    business { create(:business) }
  end

  factory :bowling, parent: :activity, class: 'Activity' do
  end
end
