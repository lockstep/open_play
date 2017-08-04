FactoryGirl.define do
  factory :reservable do
    name "Item 1"
    start_time '09:00:00'
    end_time '17:00:00'
    interval 60
    activity { create(:activity) }
    maximum_players 30
    weekday_price_cents 500
    weekday_price_currency 'USD'
    weekend_price_cents 1000
    weekend_price_currency 'USD'
    per_person_weekday_price_cents 1500
    per_person_weekday_price_currency 'USD'
    per_person_weekend_price_cents 2000
    per_person_weekend_price_currency 'USD'
  end

  factory :lane, parent: :reservable, class: 'Lane' do
    name "Lane 1"
  end

  factory :lane_with_canadian_currency, parent: :lane do
    weekday_price_cents 1000
    weekday_price_currency 'CAD'
    weekend_price_cents 1500
    weekend_price_currency 'CAD'
    per_person_weekday_price_cents 1500
    per_person_weekday_price_currency 'CAD'
    per_person_weekend_price_cents 2000
    per_person_weekend_price_currency 'CAD'
  end

  factory :room, parent: :reservable, class: 'Room' do
    name "Room 1"
  end
end
