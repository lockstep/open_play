describe Business do
  describe 'phone_number number' do
    context 'correct format' do
      it 'is valid' do
        payment = Business.new(phone_number: '+1 650-253-0000')
        payment.valid?
        expect(payment.errors.has_key?(:phone_number)).to eq false
      end
      it 'is valid' do
        payment = Business.new(phone_number: '16502530000')
        payment.valid?
        expect(payment.errors.has_key?(:phone_number)).to eq false
      end
      it 'is valid' do
        payment = Business.new(phone_number: '001800 4412904')
        payment.valid?
        expect(payment.errors.has_key?(:phone_number)).to eq false
      end
      it 'is valid' do
        payment = Business.new(phone_number: '1-800-123-4567')
        payment.valid?
        expect(payment.errors.has_key?(:phone_number)).to eq false
      end
      it 'is valid' do
        payment = Business.new(phone_number: '+1 888 747 7474')
        payment.valid?
        expect(payment.errors.has_key?(:phone_number)).to eq false
      end
    end
    context 'incorrect format' do
      it 'is invalid' do
        payment = Business.new(phone_number: '+1 650-253-000')
        payment.valid?
        expect(payment.errors[:phone_number][0]).to match 'invalid characters'
      end
      it 'is invalid' do
        payment = Business.new(phone_number: '001800_4412904')
        payment.valid?
        expect(payment.errors[:phone_number][0]).to match 'invalid characters'
      end
      it 'is invalid' do
        payment = Business.new(phone_number: '1-800_123-4567')
        payment.valid?
        expect(payment.errors[:phone_number][0]).to match 'invalid characters'
      end
      it 'is invalid' do
        payment = Business.new(phone_number: '-1 888 747 7474')
        payment.valid?
        expect(payment.errors[:phone_number][0]).to match 'invalid characters'
      end
    end
  end
end
