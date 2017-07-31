class StripeCharger
  def initialize(amount, token_id)
    @amount = amount
    @token_id = token_id
  end

  def amount_in_cents
    @amount * 100
  end

  def currency
    'usd'
  end

  def charge
    charge_result = Stripe::Charge.create(
      amount: amount_in_cents.to_i, currency: currency, source: @token_id,
      expand: ['balance_transaction']
    )
    fee = charge_result['balance_transaction']['fee'] || 0
    fee / 100.0
  end
end
