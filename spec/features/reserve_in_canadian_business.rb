feature 'Reserve in Canadian currency', :js do
  context 'canadian business exists' do
    before do
      business = create(:business)
      bowling = create(:bowling, business: business)
      reservable = create(:lane_with_canadian_currency, activity: bowling)
    end

    scenario 'user see booking price in canadian currency' do
      expect_stripe_to_receive_canadian_dollar

      visit root_path
      search_activities
      reserve_a_lane
      complete_reservation
    end
  end

  def reserve_a_lane
    click_on '11:00'
    click_on 'Book'
  end

  def complete_reservation
    fill_in 'guest[first_name]', with: 'Hello'
    fill_in 'guest[last_name]', with: 'World'
    fill_in 'guest[email]', with: 'hello@example.com'
    fill_in 'guest[phone_number]', with: '0863742661'

    stub_stripe_checkout_handler
    click_on 'Complete Reservation'
    expect(page).to have_content 'Thank you for your reservation!'
  end

  def expect_stripe_to_receive_canadian_dollar
    expect(Stripe::Charge).to receive(:create).with(
      hash_including(amount: 2600, currency: 'cad')
    ).and_return({"balance_transaction" => {"fee" => 149}})
  end
end
