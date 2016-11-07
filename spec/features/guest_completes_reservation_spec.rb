feature 'Guest Complete Reservation', :js do

  context 'a lane exists' do
    background do
      owner = create(:user)
      business = create(:business, user: owner)
      bowling = create(:bowling, business: business)
      create(:lane, activity: bowling)
    end
    scenario 'booking successful' do
      visit root_path
      search_activities
      click_on '11:00'
      click_on 'Book'

      stub_stripe_charge_create
      stub_stripe_checkout_handler
      fill_in_guest_form
      click_on 'Complete Reservation'

      expect(page).to have_content 'Reservation Info'
      expect(page).to have_content 'peter pan'
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
      context 'last name is omitted' do
        scenario 'booking unsuccessful' do
          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'
          fill_in_guest_form(last_name: '')
          click_on 'Complete Reservation'

          expect(page).to have_content "Last name can't be blank"
        end
      end
      context 'email is omitted' do
        scenario 'booking unsuccessful' do
          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'
          fill_in_guest_form(email: '')
          click_on 'Complete Reservation'

          expect(page).to have_content "Email can't be blank"
        end
      end
      context 'email is invalid format' do
        scenario 'booking unsuccessful' do
          visit root_path
          search_activities
          click_on '11:00'
          click_on 'Book'
          fill_in_guest_form(email: 'abc')
          click_on 'Complete Reservation'

          expect(page).to have_content 'Email is invalid'
        end
      end
    end
  end

  def fill_in_guest_form(overrides={})
    fill_in :guest_first_name, with: overrides[:first_name] || "peter"
    fill_in :guest_last_name, with: overrides[:last_name] || 'pan'
    fill_in :guest_email, with: overrides[:email] || 'peter-pan@gmail.com'
  end
end