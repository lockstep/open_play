describe Activity do

  describe '#build_reservable' do
    context 'Bowling exists' do
      before do
        @bowling = Activity.create(activity_params)
      end
      scenario 'builds a lane' do
        reservable = @bowling.build_reservable
        expect(reservable.type).to eq 'Lane'
        reservable.update_attributes({name: 'Lane 1', interval: 30})
        expect(Reservable.find(reservable.id).class).to eq Lane
      end
    end

    context 'Laser tag exists' do
      before do
        @laser_tag = Activity.create(activity_params(type: 'LaserTag'))
      end
      scenario 'builds a room' do
        reservable = @laser_tag.build_reservable
        expect(reservable.type).to eq 'Room'
        reservable.update_attributes({name: 'Room 1', interval: 30, maximum_players: 30})
        expect(Reservable.find(reservable.id).class).to eq Room
      end
    end
  end

  def activity_params(overrides={})
    {
      name: "Country Club",
      business: create(:business),
      start_time: '08:00',
      end_time: '20:00',
      type: overrides[:type] || 'Bowling'
    }
  end

end
