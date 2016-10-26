feature 'View User Reservations', :js do
  background do
    @user = create(:user)
    business = create(:business, user: @user)

    @bowling = create(:bowling, business: business)
    @lane_one = create(:lane, name: 'lane_one', activity: @bowling,
      weekday_price: 10, per_person_weekday_price: 20)
    @lane_two = create(:lane, name: 'lane_two', activity: @bowling,
      weekday_price: 15, per_person_weekday_price: 30)
  end
  include_context 'logged in user'

  context 'bookings exist' do
    background do
      order_1 = create(:order, user: @user, activity: @bowling)
      @booking_1 = create(:booking, order: order_1, reservable: @lane_one,
        start_time: '10:00:00', end_time: '11:00:00', booking_date: '2016-10-13',
        number_of_players: 2)
      @booking_2 = create(:booking, order: order_1, reservable: @lane_two,
        start_time: '14:00:00', end_time: '15:00:00', booking_date: '2016-10-13',
        number_of_players: 3)

      @user_2 = create(:user)
      order_2 = create(:order, user: @user_2, activity: @bowling)
      @booking_3 = create(:booking, order: order_2, reservable: @lane_one,
        start_time: '11:00:00', end_time: '12:00:00', booking_date: '2016-10-13',
        number_of_players: 4)
      @booking_4 = create(:booking, order: order_2, reservable: @lane_two,
        start_time: '15:00:00', end_time: '16:00:00', booking_date: '2016-10-13',
        number_of_players: 5)

      order_3 = create(:order, user: @user, activity: @bowling)
      @booking_5 = create(:booking, order: order_3, reservable: @lane_one,
        start_time: '12:00:00', end_time: '13:00:00', booking_date: '2016-10-17',
        number_of_players: 1)
      @booking_6 = create(:booking, order: order_3, reservable: @lane_two,
        start_time: '16:00:00', end_time: '17:00:00', booking_date: '2016-10-17',
        number_of_players: 1)
    end


    context 'booking_date and system date are the same' do
      scenario 'shows reservations' do
        travel_to Time.new(2016, 10, 13) do
          visit root_path
          within("nav") do
            click_button @user.email
          end
          click_link 'Your Bookings'
        end

        expect(page).to have_content @bowling.name
        expect(page).to have_content @lane_one.name
        expect(page).to have_content '10:00 AM - 11:00 AM'
        expect(page).to have_content '13 October'
        expect(find("#number_of_people_from_booking_#{@booking_1.id}")).to have_content 2
        expect(page).to have_content @lane_two.name
        expect(page).to have_content '02:00 PM - 03:00 PM'
        expect(page).to have_content '13 October'
        expect(find("#number_of_people_from_booking_#{@booking_2.id}")).to have_content 3
        expect(page).to have_content '$ 155.0'

        expect(page).to_not have_content '11:00 AM - 12:00 PM'
        expect(page).to_not have_content '04:00 PM - 05:00 PM'
        expect(page).to_not have_content '$ 255.0'

        expect(page).to_not have_content '12:00 PM - 01:00 PM'
        expect(page).to_not have_content '04:00 PM - 05:00 PM'
        expect(page).to_not have_content '$ 75.0'
      end
    end

    context 'booking_date and system date are not the same' do
      scenario 'does not show reservations' do
        travel_to Time.new(2016, 10, 14) do
          visit root_path
          within("nav") do
            click_button @user.email
          end
          click_link 'Your Bookings'
        end

        expect(page).to_not have_content @bowling.name
        expect(page).to_not have_content @lane_one.name
        expect(page).to_not have_content @lane_two.name
      end

      context 'select a booking_date from calendar' do
        scenario 'shows reservations' do
          travel_to Time.new(2016, 10, 14) do
            visit root_path
            within("nav") do
              click_button @user.email
            end
            click_link 'Your Bookings'
            select_a_booking_date('2016-10-13')
          end

          expect(page).to have_content @bowling.name
          expect(page).to have_content @lane_one.name
          expect(page).to have_content '10:00 AM - 11:00 AM'
          expect(page).to have_content '13 October'
          expect(find("#number_of_people_from_booking_#{@booking_1.id}")).to have_content 2
          expect(page).to have_content @lane_two.name
          expect(page).to have_content '02:00 PM - 03:00 PM'
          expect(page).to have_content '13 October'
          expect(find("#number_of_people_from_booking_#{@booking_2.id}")).to have_content 3
          expect(page).to have_content '$ 155.0'

          expect(page).to_not have_content '11:00 AM - 12:00 PM'
          expect(page).to_not have_content '03:00 PM - 04:00 PM'
          expect(page).to_not have_content '$ 255.0'

          expect(page).to_not have_content '12:00 PM - 01:00 PM'
          expect(page).to_not have_content '04:00 PM - 05:00 PM'
          expect(page).to_not have_content '$ 75.0'
        end
      end
    end
  end

  def select_a_booking_date(date)
    page.execute_script("$('#reservations-booking-date').val('" + date + "').trigger('change')")
  end
end
