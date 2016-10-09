FactoryGirl.define do
  factory :booking do
    start_time '09:00:00'
    end_time '10:00:00'
    booking_date '2001-02-03'
    number_of_players 10
    order { create(:order) }
    reservable { create(:room) }
  end
end
