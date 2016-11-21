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

    scenario 'booking successful' do
      visit root_path
      search_activities
      click_on '11:00'
      click_on 'Book'

      stub_stripe_checkout_handler
      stub_processing_order
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
    end
  end

  def fill_in_guest_form(overrides={})
    fill_in :guest_first_name, with: overrides[:first_name] || "peter"
    fill_in :guest_last_name, with: overrides[:last_name] || 'pan'
    fill_in :guest_email, with: overrides[:email] || 'peter-pan@gmail.com'
    fill_in :guest_phone_number, with: overrides[:phone_number] || '+1 650-253-0000'
  end
end
