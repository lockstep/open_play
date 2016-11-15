describe Activity do

  describe '#search' do
    before do
      create(:bowling, start_time: '08:00', end_time: '08:00')
      create(:laser_tag)
    end
    context 'search by type' do
      scenario 'returns the search results correctly' do
        results = Activity.search('5 Nov 2016', '11:00', 'LaserTag')
        expect(results.count).to eq 1
        expect(results.first.class).to eq LaserTag
      end
    end
  end

end
