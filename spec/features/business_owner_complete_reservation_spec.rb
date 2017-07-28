feature 'Business Owner Complete Reservation', :js do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
    @bowling = create(:bowling, business: @business)
    @lane = create(:lane, activity: @bowling)
  end
  include_context 'logged in user'

  context 'booking a lane' do
    before do
      visit root_path
      search_activities
      click_on '11:00'
      click_on 'Book'
    end

    scenario 'displays the booking info correctly' do
      expect(page).to have_content 'Monday, January 20'
      expect(page).to have_content @bowling.name
      expect(page).to have_content '11:00 AM - 12:00 PM'
      expect(page).to have_content '0/30'
      expect(page).to have_content '$ 5'
      expect(page).to have_content '$ 15'
      expect(page).to_not have_content 'Subtotal: $ 20'
      expect(page).to_not have_content 'Open Play Fee: $ 1'
      expect(page).to have_content "By Manager"
      expect(page).to have_content 'Total: -'
      expect(find_field('order_bookings_0_number_of_players').value).to eq '1'
    end

    scenario 'successfully completes an order with zero total price' do
      expect(StripeCharger).to_not receive(:new)
      expect(SendConfirmationOrderService).to receive(:call).with(
        hash_including(order: an_instance_of(Order), confirmation_channel: 'email')
      ).and_return(false)

      click_on 'Complete Reservation'
      expect(page).to have_content 'Reservation Info'
      expect(page).to have_content 'Tom Cruise'
      expect(page.find('.total_price').text).to eq '-'
    end
  end
end
