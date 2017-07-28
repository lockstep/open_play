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
end
