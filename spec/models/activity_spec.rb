describe Activity do
  describe '#search' do
    before do
      create(:bowling, start_time: '08:00', end_time: '08:00')
      create(:laser_tag)
    end

    context 'search by type' do
      it 'returns the search results correctly' do
        results = Activity.search(activity_type: 'LaserTag')
        expect(results.count).to eq 1
        expect(results.first.class).to eq LaserTag
      end
    end
  end

  describe '.types' do
    it 'includes bowling' do
      expect(described_class.types).to include('bowling')
    end

    it 'includes laser_tag' do
      expect(described_class.types).to include('laser_tag')
    end

    it 'includes escape_room' do
      expect(described_class.types).to include('escape_room')
    end
  end

  describe '#build_reservable' do
    it 'builds a lane' do
      bowling = build_stubbed(:bowling, start_time: '08:00', end_time: '10:00')
      reservable = bowling.build_reservable('Lane')
      expect(reservable.type).to eq 'Lane'
      expect(reservable.start_time).to eq Time.parse('2000-01-01 08:00:00 +0000')
      expect(reservable.end_time).to eq Time.parse('2000-01-01 10:00:00 +0000')
    end

    it 'builds a room' do
      laser_tag = build_stubbed(:laser_tag, start_time: '08:00', end_time: '10:00')
      reservable = laser_tag.build_reservable('Room')
      expect(reservable.type).to eq 'Room'
      expect(reservable.start_time).to eq Time.parse('2000-01-01 08:00:00 +0000')
      expect(reservable.end_time).to eq Time.parse('2000-01-01 10:00:00 +0000')
    end

    it 'builds a party room' do
      laser_tag = build_stubbed(:laser_tag, start_time: '08:00', end_time: '10:00')
      reservable = laser_tag.build_reservable('PartyRoom')
      expect(reservable.type).to eq 'PartyRoom'
      expect(reservable.start_time).to eq Time.parse('2000-01-01 08:00:00 +0000')
      expect(reservable.end_time).to eq Time.parse('2000-01-01 10:00:00 +0000')
    end
  end
end
