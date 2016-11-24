describe ClosedSchedulesHelper do
  describe '#plural_form_of_reservable_type' do
    it 'returns correct name of reservable type' do
      activity = create(:bowling)
      reservable_type = plural_form_of_reservable_type(activity)
      expect(reservable_type).to eq 'Reservables'
    end

    it 'returns correct name of reservable type' do
      lane = create(:lane)
      reservable_type = plural_form_of_reservable_type(lane.activity)
      expect(reservable_type).to eq 'Lanes'
    end
  end
end
