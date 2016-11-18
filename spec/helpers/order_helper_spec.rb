describe OrderHelper do
  describe '#present_booking_price' do
    context 'booking_price is zero' do
      it 'displays booking_price correctly' do
        expect(present_booking_price(0)).to eq 'Paid externally'
      end
    end
    context 'booking_price is not zero' do
      it 'displays booking_price correctly' do
        expect(present_booking_price(15.5)).to eq '$ 15.5'
      end
    end
  end
end
