feature 'Search Activities', js: true do
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
          page.execute_script("$('#timepicker').val('16:00')")
          page.select 'Bowling', :from => 'activity_type'
          click_on 'Search'
          expect(page).to have_content @bowling.name
          expect(page).to have_content @bowling_2.name
        end
        scenario 'shows the requested time first and go to the end of the day' do
          visit root_path
          page.execute_script("$('#timepicker').val('16:00')")
          page.select 'Bowling', :from => 'activity_type'
          click_on 'Search'
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
              booking_date: '2016-10-10',
              number_of_players: 2,
              reservable: @lane,
              order: @order
            )
            Booking.create(
              start_time: '18:00',
              end_time: '19:00',
              booking_date: '2016-10-10',
              number_of_players: 2,
              reservable: @lane_2,
              order: @order
            )
          end
          scenario 'disbles the unavailable time slots' do
            visit root_path
            page.execute_script("$('#datepicker').val('2016-10-10')")
            page.execute_script("$('#timepicker').val('16:00')")
            page.select 'Bowling', :from => 'activity_type'
            click_on 'Search'
            expect(page).to have_button('16:00', disabled: true)
            expect(page).to have_button('18:00', disabled: true)
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
  end

end
