describe Bowling do
  describe '#build_reservable' do
    before do
      @bowling = Activity.create(activity_params)
    end
    scenario 'builds a lane' do
      reservable = @bowling.build_reservable
      expect(reservable.type).to eq 'Lane'
      reservable.update_attributes({
        name: 'Lane 1',
        interval: 30,
        maximum_players: 30,
        weekday_price: 15,
        weekend_price: 20,
        per_person_weekday_price: 15,
        per_person_weekend_price: 20
      })
      expect(Reservable.find(reservable.id).class).to eq Lane
    end
  end

  def activity_params
    {
      name: "Country Club",
      business: create(:business),
      start_time: '08:00',
      end_time: '20:00',
      type: 'Bowling'
    }
  end
end
