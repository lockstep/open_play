feature 'Guest Complete Reservation', :js do

  context 'a lane exists' do
    background do
      owner = create(:user)
      business = create(:business, user: owner)
      bowling = create(:bowling, business: business)
      create(:lane, activity: bowling)
    end

    scenario 'sees guest form' do
      visit root_path
      search_activities
      click_on '11:00'
      click_on 'Book'

      within '#new-order-form' do
        expect(page).to have_content 'First name'
        expect(page).to have_content 'Last name'
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Phone number'
      end
    end

    context 'guest form is valid' do
      context 'new guest' do
        scenario 'booking successful' do
          expect(StripeCharger).to(
            receive(:charge)
          ).and_return(149)
          expect(SendConfirmationOrderService).to receive(:call).with(
            hash_including(order: an_instance_of(Order), confirmation_channel: 'email')
          )

          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'

          stub_stripe_checkout_handler
          fill_in_guest_form
          click_on 'Complete Reservation'

          expect(page).to have_content 'Reservation Info'
          expect(page).to have_content 'peter pan'
          expect(Order.count).to eq 1
          expect(Guest.count).to eq 1
          order = Order.first
          guest = Guest.first
          expect(order.guest).to eq guest
          expect(order.price_cents).to eq 2100
          expect(order.stripe_fee_cents).to eq 149
          expect(order.open_play_fee_cents).to eq 100
          expect(guest.first_name).to eq 'peter'
          expect(guest.last_name).to eq 'pan'
          expect(guest.email).to eq 'peter-pan@gmail.com'
          expect(guest.phone_number).to eq '+1 650-253-0000'
        end
      end

      context 'existing guest' do
        before do
          create(:guest, first_name: 'peter', last_name: 'pan',
            email: 'peter-pan@gmail.com', phone_number: '+1 650-253-0000')
        end

        scenario 'booking successful' do
          expect(StripeCharger).to(
            receive(:charge)
          ).and_return(1.49)
          expect(SendConfirmationOrderService).to receive(:call).with(
            hash_including(order: an_instance_of(Order), confirmation_channel: 'email')
          )

          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'

          stub_stripe_checkout_handler
          fill_in_guest_form
          click_on 'Complete Reservation'

          expect(page).to have_content 'Reservation Info'
          expect(page).to have_content 'peter pan'
          expect(Order.count).to eq 1
          expect(Guest.count).to eq 1
          order = Order.first
          guest = Guest.last
          expect(order.guest).to eq guest
          expect(guest.first_name).to eq 'peter'
          expect(guest.last_name).to eq 'pan'
          expect(guest.email).to eq 'peter-pan@gmail.com'
          expect(guest.phone_number).to eq '+1 650-253-0000'
        end
      end
    end

    context 'guest form is invalid' do
      context 'first name is omitted' do
        scenario 'booking unsuccessful' do
          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'
          fill_in_guest_form(first_name: '')
          click_on 'Complete Reservation'

          expect(page).to have_content "First name can't be blank"
        end
      end
    end
  end

  def fill_in_guest_form(overrides={})
    fill_in :guest_first_name, with: overrides[:first_name] || "peter"
    fill_in :guest_last_name, with: overrides[:last_name] || 'pan'
    fill_in :guest_email, with: overrides[:email] || 'peter-pan@gmail.com'
    fill_in :guest_phone_number, with: overrides[:phone_number] || '+1 650-253-0000'
    choose 'confirmation_channel_email'
  end
end
