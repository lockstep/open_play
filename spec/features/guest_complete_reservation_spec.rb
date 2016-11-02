feature 'Guest Complete Reservation', :js do
  include ReservationHelpers
  include StripeHelpers

  context 'a lane already exists' do
    background do
      user = create(:user)
      business = create(:business, user: user)
      bowling = create(:bowling, business: business)
      create(:lane, activity: bowling)
      create(:user, email: 'guest-user@gmail.com')
    end
    scenario 'booking successful' do
      visit root_path
      search_activities
      click_on '11:00'
      click_on 'Book'
      click_on 'Complete Reservation'

      stub_stripe_charge_create
      stub_stripe_checkout_handler
      fill_in_guest_form

      expect(page).to have_content 'Thank you for your purchase'
    end

    context 'guest form is invalid' do
      context 'first name is omitted' do
        scenario 'booking unsuccessful' do
          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'
          click_on 'Complete Reservation'
          fill_in_guest_form(first_name: '')

          expect(page).to have_content 'First name is required'
        end
      end
      context 'last name is omitted' do
        scenario 'booking unsuccessful' do
          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'
          click_on 'Complete Reservation'
          fill_in_guest_form(last_name: '')

          expect(page).to have_content 'Last name is required'
        end
      end
      context 'email is omitted' do
        scenario 'booking unsuccessful' do
          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'
          click_on 'Complete Reservation'
          fill_in_guest_form(email: '')

          expect(page).to have_content 'Email is required'
        end
      end
      context 'email is invalid format' do
        scenario 'booking unsuccessful' do
          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'
          click_on 'Complete Reservation'
          fill_in_guest_form(email: 'abc')

          expect(page).to have_content 'Email is invalid'
        end
      end
    end
  end

  def fill_in_guest_form(overrides={})
    within('#guest-modal') do
      fill_in 'first-name', with: overrides[:first_name] || "peter"
      fill_in 'last-name', with: overrides[:last_name] || 'pan'
      fill_in 'email', with: overrides[:email] || 'peter-pan@gmail.com'
      click_on 'Submit'
    end
  end
end
