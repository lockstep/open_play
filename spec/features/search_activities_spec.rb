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
      @bowling_3 = create(:bowling, name: 'Archived Bowling',
        business: @business, archived: true
      )
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
        @lane_3 = create(
          :lane,
          name: 'Lane 3',
          activity: @bowling,
          start_time: '10:00',
          end_time: '20:00',
          archived: true
        )
      end
      context 'results found' do
        scenario 'shows list of active activities' do
          visit root_path
          search_activities(booking_time: '4:00pm')
          expect(page).to have_content @bowling.name
          expect(page).to have_content @bowling_2.name
          expect(page).to_not have_content @bowling_3.name
          expect(page).to_not have_content 'view more'
        end
        scenario 'returns the opening time till the closing time' do
          visit root_path
          search_activities(booking_time: '1:00pm')
          expect(page).to have_content @lane.name
          expect(page).to have_content '08:00'
          expect(page).to have_content '16:00'
          expect(page).to have_content @lane_2.name
          expect(page).to have_content '10:00'
          expect(page).to have_content '19:00'
        end
        scenario 'not show archived reservables' do
          visit root_path
          search_activities(booking_time: '1:00pm')
          expect(page).to have_content @lane.name
          expect(page).to have_content @lane_2.name
          expect(page).to_not have_content @lane_3.name
        end
        context '24-hour activity' do
          background do
            @bowling.update(start_time: '09:00', end_time: '09:00')
          end
          scenario 'shows 24-hour activity' do
            visit root_path
            search_activities(booking_time: '4:00pm')
            expect(page).to have_content @bowling.name
          end
        end
        context 'has bookings' do
          background do
            @order = create(:order, activity: @bowling, user: @user)
            create(
              :booking,
              start_time: '16:00',
              end_time: '17:00',
              booking_date: '2020-01-20',
              number_of_players: 2,
              reservable: @lane,
              order: @order
            )
            create(
              :booking,
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
          context 'allow back-to-back bookings' do
            scenario 'shows the back-to-back time slots as available' do
              visit root_path
              search_activities(booking_date: '20 Jan 2020')
              expect(page).to have_button('17:00', disabled: false)
              expect(page).to have_button('19:00', disabled: false)
            end
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

        context 'Bowling has many lanes' do
          before do
            @lane_4 = create(
              :lane,
              name: 'Lane 4',
              activity: @bowling
            )
          end
          scenario 'shows the view more link' do
            visit root_path
            search_activities
            expect(page).to have_content @lane.name
            expect(page).to have_content @lane_2.name
            expect(page).to_not have_content @lane_4.name
            expect(page).to have_content 'view more'
          end
          context 'view more link exists' do
            scenario 'shows the rest of the lanes' do
              visit root_path
              search_activities
              click_on 'view more'
              expect(page).to have_content @lane.name
              expect(page).to have_content @lane_2.name
              expect(page).to have_content @lane_4.name
            end
          end
        end

      end

      context 'user is not logged in' do
        scenario 'still shows the list of activities' do
          visit root_path
          within("nav") do
            click_button @user.email
          end
          click_link 'Log Out'
          search_activities
          expect(page).to have_content @bowling.name
          expect(page).to have_content @bowling_2.name
        end
      end
    end

    context 'no results found' do
      scenario 'shows the appropiate message' do
        visit root_path
        search_activities(activity_type: 'Laser tag')
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

  describe 'Laser tag exists' do
    context 'prevents back-to-back bookings' do
      background do
        @laser_tag = create(
          :laser_tag,
          prevent_back_to_back_booking: true,
          business: @business
        )
        @room = create(:room, activity: @laser_tag)
      end
      scenario 'disables back-to-back slots' do
        visit root_path
        search_activities(activity_type: 'Laser tag')
        click_on '12:00'
        expect(page).to have_button('11:00', disabled: true)
        expect(page).to have_button('13:00', disabled: true)
      end
      context 'the user tries to do back-to-back bookings by searching again' do
        background do
          @order = create(:order, user: @user, activity: @laser_tag)
          @booking = create(
            :booking,
            start_time: '12:00',
            end_time: '13:00',
            booking_date: '2020-01-20',
            number_of_players: 2,
            reservable: @room,
            order: @order
          )
        end
        scenario 'still disables the back-to-back slots' do
          visit root_path
          search_activities(activity_type: 'Laser tag')
          expect(page).to have_button('11:00', disabled: true)
          expect(page).to have_button('13:00', disabled: true)
        end
        context 'allows multi-party bookings' do
          background do
            @laser_tag.update(allow_multi_party_bookings: true)
          end
          scenario 'still disables the back-to-back slots' do
            visit root_path
            search_activities(activity_type: 'Laser tag')
            expect(page).to have_button('11:00', disabled: true)
            expect(page).to have_button('13:00', disabled: true)
          end
          context 'some spots left on the booked time slot' do
            scenario 'enables the booked time slot' do
              visit root_path
              search_activities(activity_type: 'Laser tag')
              expect(page).to have_button('12:00', disabled: false)
            end
          end
          context 'no spots left on the booked time slot' do
            background do
              @booking = create(
                :booking,
                start_time: '12:00',
                end_time: '13:00',
                booking_date: '2020-01-20',
                number_of_players: 28,
                reservable: @room,
                order: @order
              )
            end
            scenario 'disabled the booked time slot' do
              visit root_path
              search_activities(activity_type: 'Laser tag')
              expect(page).to have_button('12:00', disabled: true)
            end
          end
        end
      end
    end
  end

end
