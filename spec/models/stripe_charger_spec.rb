describe StripeCharger do
  describe '#charge' do
    it 'Stripe get charged with valid params' do
      expect(Stripe::Charge).to receive(:create).with(
        hash_including(amount: 1000, currency: 'usd', source: 'abc123')
      ).and_return({'balance_transaction' => {'fee' => 149}})
      StripeCharger.charge(Money.new(1000, 'USD'), 'abc123')
    end
  end
end
