FactoryGirl.define do
  factory :activity do
    name "Country Club"
    start_time '09:00:00'
    end_time '17:00:00'
    prevent_back_to_back_booking false
    allow_multi_party_bookings false
    business { create(:business) }
  end

  factory :bowling, parent: :activity, class: 'Bowling' do
    name "Country Club Lanes"
  end

  factory :laser_tag, parent: :activity, class: 'LaserTag' do
    name "Country Club Laser Tag"
  end
end
