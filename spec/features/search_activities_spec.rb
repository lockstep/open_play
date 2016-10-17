feature 'Search Activities', js: true do
  include ReservationHelpers

  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  describe 'Bowlings exist' do
    background do
      @bowling = create(:bowling, business: @business)
      @bowling_2 = create(:bowling, name: 'Classic Bowling', business: @business)
    end
    context 'has multiple lanes' do
      background do
        @lane = create(
          :lane,
          start_time: '08:00',
          end_time: '17:00',
          activity: @bowling
        )
        @lane_2 = create(
          :lane,
          name: 'Lane 2',
          activity: @bowling,
          start_time: '10:00',
          end_time: '20:00'
        )
      end
      context 'results found' do
        scenario 'shows list of activities' do
          visit root_path
          search_activities(booking_time: '4:00pm')
          expect(page).to have_content @bowling.name
          expect(page).to have_content @bowling_2.name
        end
        scenario 'shows the requested time first and go to the end of the day' do
          visit root_path
          search_activities(booking_time: '4:00pm')
          expect(page).to have_content @lane.name
          expect(page).to have_content '16:00'
          expect(page).to have_content @lane_2.name
          expect(page).to have_content '16:00 17:00 18:00 19:00'
        end
        context 'has bookings' do
          background do
            @order = Order.create(user: create(:user))
            Booking.create(
              start_time: '16:00',
              end_time: '17:00',
              booking_date: '2020-01-20',
              number_of_players: 2,
              reservable: @lane,
              order: @order
            )
            Booking.create(
              start_time: '18:00',
              end_time: '19:00',
              booking_date: '2020-01-20',
              number_of_players: 2,
              reservable: @lane_2,
              order: @order
            )
          end
          scenario 'disbles the unavailable time slots' do
            visit root_path
            search_activities(booking_date: '20 Jan 2020', booking_time: '4:00pm')
            expect(page).to have_button('16:00', disabled: true)
            expect(page).to have_button('18:00', disabled: true)
          end
        end
        context 'search with no time' do
          scenario 'displays every time slots of each activity' do
            visit root_path
            search_activities(booking_time: '')
            expect(page).to have_content @lane.name
            expect(page).to have_content '08:00 09:00 10:00 11:00 12:00 13:00'
            expect(page).to have_content '14:00 15:00 16:00 17:00 18:00 19:00'
          end
        end
      end
    end

    context 'no results found' do
      scenario 'shows the appropiate message' do
        visit root_path
        page.select 'Laser tag', :from => 'activity_type'
        click_on 'Search'
        expect(page).to have_content 'No results found'
      end
    end

    context 'invalid params' do
      context '#booking_date' do
        scenario 'shows the appropiate message' do
          visit root_path
          search_activities(booking_date: '')
          expect(page).to have_content 'Date is required.'
        end
      end
    end
  end

end
