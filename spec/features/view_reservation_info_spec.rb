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
          expect(page).to have_content '$15'
          expect(page).to have_content '$45'
        end
        within('.booking_1') do
          expect(page).to have_content '01:00 PM - 02:00 PM'
          expect(page).to have_content '$5'
          expect(page).to have_content '$15'
        end
        within('.booking_2') do
          expect(page).to have_content '03:00 PM - 05:00 PM'
          expect(page).to have_content '$10'
          expect(page).to have_content '$30'
        end
      end
    end

    context 'user changes number of players' do
      context 'user is a business owner' do
        before do
          @business.update(user: @user)
        end

        scenario 'sees the total price changes' do
          travel_to Time.new(2017, 1, 12) do
            visit root_path
            search_activities
            find('button', text: '09:00').trigger('click')
            find('button', text: '15:00').trigger('click')
            click_on 'Book'
            fill_in 'order_bookings_0_number_of_players', with: 2
            fill_in 'order_bookings_1_number_of_players', with: 2
            expect(page).to have_content 'Summary'
            expect(page).to have_content 'Free Reservation (By Manager)'
            expect(page).to have_content 'Total: -'
          end
        end
      end

      context 'user is not a business owner' do
        scenario 'sees the total price changes' do
          travel_to Time.new(2017, 1, 12) do
            visit root_path
            search_activities
            find('button', text: '09:00').trigger('click')
            find('button', text: '15:00').trigger('click')
            click_on 'Book'
            fill_in 'order_bookings_0_number_of_players', with: 2
            fill_in 'order_bookings_1_number_of_players', with: 2
            expect(page).to have_content 'Summary'
            expect(page).to have_content 'Subtotal: $70'
            expect(page).to have_content 'Open Play Fee: $1'
            expect(page).to have_content 'Total: $71'
          end
        end
      end
    end
  end
end
