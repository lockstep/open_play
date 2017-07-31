describe StripeCharger do
  describe '#charge' do
    it 'Stripe get charged with valid params' do
      expect(Stripe::Charge).to receive(:create).with(
        hash_including(amount: 1000, currency: 'usd', source: 'abc123')
      ).and_return({'balance_transaction' => {'fee' => 149}})
      StripeCharger.new(10.0, 'abc123').charge
    end
  end
end
