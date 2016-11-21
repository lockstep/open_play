describe Guest do
  subject { described_class.new(
    first_name: 'mark',
    last_name: 'zuckerberg',
    email: 'mark@locksteplap.com'
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

    it 'is not valid if an invalid email format' do
      subject.email = 'abc'
      expect(subject).to_not be_valid
    end
  end
end
