describe Guest do
  subject { described_class.new(
    first_name: 'mark',
    last_name: 'zuckerberg',
    email: 'mark@locksteplap.com',
    phone_number: '+1 650-253-0000'
  )}

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a first name' do
      subject.first_name = ''
      expect(subject).to_not be_valid
    end

    it 'is not valid without a last name' do
      subject.last_name = ''
      expect(subject).to_not be_valid
    end

    it 'is not valid without an email' do
      subject.email = ''
      expect(subject).to_not be_valid
    end

    it 'is not valid if an invalid email' do
      subject.email = 'abc'
      expect(subject).to_not be_valid
    end

    it 'is not valid without a phone number' do
      subject.phone_number = ''
      expect(subject).to_not be_valid
    end

    it 'is not valid without an valid phone number' do
      subject.phone_number = '001800_4412904'
      expect(subject).to_not be_valid
    end
  end
end
