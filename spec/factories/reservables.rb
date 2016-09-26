FactoryGirl.define do
  factory :reservable do
    name "Item 1"
    interval 60
    activity { create(:activity) }
  end

  factory :lane, parent: :reservable, class: 'Lane' do
    name "Lane 1"
  end

  factory :room, parent: :reservable, class: 'Room' do
    name "Room 1"
  end
end
