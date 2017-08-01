class StripeCharger
  def self.charge(amount, token_id)
    amount_in_cents = amount * 100
    charge_result = Stripe::Charge.create(
      amount: amount_in_cents.to_i, currency: 'usd', source: token_id,
      expand: ['balance_transaction']
    )
    charge_result['balance_transaction']['fee'] || 0
  end
end
