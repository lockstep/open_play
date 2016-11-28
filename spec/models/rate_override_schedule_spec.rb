describe RateOverrideSchedule do
  subject { described_class.new(
    label: 'black friday',
    overridden_on: '7 Nov 2016',
    overridden_days: '',
    overridden_all_day: true,
    overridden_specific_day: true,
    overriding_begins_at: '',
    overriding_ends_at: '',
    overridden_all_reservables: true,
    price: '10.0',
    per_person_price: '15.0',
    activity_id: create(:bowling).id
  )}

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a valid label' do
      subject.label = ''
      expect(subject).to_not be_valid
    end

    it 'is not valid without a valid price' do
      subject.price = '-1'
      expect(subject).to_not be_valid
    end

    it 'is not valid without a valid price person price' do
      subject.per_person_price = '-5'
      expect(subject).to_not be_valid
    end
  end
end
