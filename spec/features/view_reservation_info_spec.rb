feature 'View Reservation Info', :js do
  background do
    @business = create(:business)
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'a lane exists' do
    background do
      @bowling = create(:bowling, business: @business)
      @lane = create(:lane, activity: @bowling)
    end

    context 'books consecutive timeslots' do
      scenario 'consolidates timeslots' do
        travel_to Time.new(2017, 1, 12) do
          visit root_path
          search_activities
          find('button', text: '09:00').trigger('click')
          find('button', text: '10:00').trigger('click')
          find('button', text: '11:00').trigger('click')
          find('button', text: '13:00').trigger('click')
          find('button', text: '15:00').trigger('click')
          find('button', text: '16:00').trigger('click')
          click_on 'Book'
        end
        within('.booking_0') do
          expect(page).to have_content '09:00 AM - 12:00 PM'
          expect(page).to have_content '$ 15'
          expect(page).to have_content '$ 45'
        end
        within('.booking_1') do
          expect(page).to have_content '01:00 PM - 02:00 PM'
          expect(page).to have_content '$ 5'
          expect(page).to have_content '$ 15'
        end
        within('.booking_2') do
          expect(page).to have_content '03:00 PM - 05:00 PM'
          expect(page).to have_content '$ 10'
          expect(page).to have_content '$ 30'
        end
      end
    end
  end
end
