FactoryGirl.define do
  factory :activity do
    name "Country Club"
    start_time '09:00:00'
    end_time '17:00:00'
    business { create(:business) }
  end

  factory :bowling, parent: :activity, class: 'Bowling' do
    name "Country Club Lanes"
  end

  factory :laser_tag, parent: :activity, class: 'LaserTag' do
    name "Country Club Laser Tag"
  end
end
