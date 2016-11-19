feature 'View User Reservations', :js do
  background do
    business = create(:business)

    @bowling = create(:bowling, business: business)
    @lane_one = create(:lane, name: 'lane_one', activity: @bowling,
      weekday_price: 5, per_person_weekday_price: 10)
    @lane_two = create(:lane, name: 'lane_two', activity: @bowling,
      weekday_price: 10, per_person_weekday_price: 15)

    @laser_tag = create(:laser_tag, business: business)
    @room_one = create(:room, name: 'room_one', activity: @laser_tag,
      weekend_price: 5, per_person_weekend_price: 10)
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'bookings exist' do
    background do
      @order_1 = create(:order, user: @user, activity: @bowling)
      @booking_1 = create(:booking, order: @order_1, reservable: @lane_two,
        start_time: '14:00:00', end_time: '15:00:00', booking_date: '2016-10-13',
        number_of_players: 3)

      @booking_2 = create(:booking, order: @order_1, reservable: @lane_one,
        start_time: '10:00:00', end_time: '11:00:00', booking_date: '2016-10-13',
        number_of_players: 2)
      @order_1.set_price_of_bookings
      @order_1.save

      @user_2 = create(:user)
      @order_2 = create(:order, user: @user_2, activity: @laser_tag)
      @booking_3 = create(:booking, order: @order_2, reservable: @room_one,
        start_time: '14:00:00', end_time: '15:00:00', booking_date: '2016-10-22',
        number_of_players: 5)
      @order_2.set_price_of_bookings
      @order_2.save

      @order_3 = create(:order, user: @user, activity: @bowling)
      @booking_4 = create(:booking, order: @order_3, reservable: @lane_two,
        start_time: '09:00:00', end_time: '10:00:00', booking_date: '2016-10-13',
        number_of_players: 3)
      @order_3.set_price_of_bookings
      @order_3.save
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

        within(:xpath, "//table/tbody/tr[1]") do
          expect(page).to have_content @order_3.id
          expect(page).to have_content @order_3.reserver_full_name
          expect(page).to have_content @bowling.name
          expect(page).to have_content @lane_two.name
          expect(page).to have_content('09:00 AM - 10:00 AM')
          expect(page).to have_content '13 October'
          expect(find("#number_of_people_from_booking_#{@booking_4.id}"))
            .to have_content @booking_4.number_of_players
          expect(page).to have_content '$ 55.0'
          expect(page).to_not have_link 'Check in'
        end
        within(:xpath, "//table/tbody/tr[2]") do
          expect(page).to have_content @order_1.id
          expect(page).to have_content @order_1.reserver_full_name
          expect(page).to have_content @bowling.name
          expect(page).to have_content @lane_one.name
          expect(page).to have_content('10:00 AM - 11:00 AM')
          expect(page).to have_content '13 October'
          expect(find("#number_of_people_from_booking_#{@booking_2.id}"))
            .to have_content @booking_2.number_of_players
          expect(page).to have_content '$ 25.0'
          expect(page).to_not have_link 'Check in'
        end
        within(:xpath, "//table/tbody/tr[3]") do
          expect(page).to have_content @order_1.id
          expect(page).to have_content @order_1.reserver_full_name
          expect(page).to have_content @bowling.name
          expect(page).to have_content @lane_two.name
          expect(page).to have_content('02:00 PM - 03:00 PM')
          expect(page).to have_content '13 October'
          expect(find("#number_of_people_from_booking_#{@booking_1.id}"))
            .to have_content @booking_1.number_of_players
          expect(page).to have_content '$ 55.0'
          expect(page).to_not have_link 'Check in'
        end
        expect(page).to_not have_content @laser_tag.name
        expect(page).to_not have_content @room_one.name
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

          within(:xpath, "//table/tbody/tr[1]") do
            expect(page).to have_content @order_3.id
            expect(page).to have_content @order_3.reserver_full_name
            expect(page).to have_content @bowling.name
            expect(page).to have_content @lane_two.name
            expect(page).to have_content('09:00 AM - 10:00 AM')
            expect(page).to have_content '13 October'
            expect(find("#number_of_people_from_booking_#{@booking_4.id}"))
              .to have_content @booking_4.number_of_players
            expect(page).to have_content '$ 55.0'
            expect(page).to_not have_link 'Check in'
          end
          within(:xpath, "//table/tbody/tr[2]") do
            expect(page).to have_content @order_1.id
            expect(page).to have_content @order_1.reserver_full_name
            expect(page).to have_content @bowling.name
            expect(page).to have_content @lane_one.name
            expect(page).to have_content('10:00 AM - 11:00 AM')
            expect(page).to have_content '13 October'
            expect(find("#number_of_people_from_booking_#{@booking_2.id}"))
              .to have_content @booking_2.number_of_players
            expect(page).to have_content '$ 25.0'
            expect(page).to_not have_link 'Check in'
          end
          within(:xpath, "//table/tbody/tr[3]") do
            expect(page).to have_content @order_1.id
            expect(page).to have_content @order_1.reserver_full_name
            expect(page).to have_content @bowling.name
            expect(page).to have_content @lane_two.name
            expect(page).to have_content('02:00 PM - 03:00 PM')
            expect(page).to have_content '13 October'
            expect(find("#number_of_people_from_booking_#{@booking_1.id}"))
              .to have_content @booking_1.number_of_players
            expect(page).to have_content '$ 55.0'
            expect(page).to_not have_link 'Check in'
          end
          expect(page).to_not have_content @laser_tag.name
          expect(page).to_not have_content @room_one.name
        end
      end
    end
  end

  def select_a_booking_date(date)
    page.execute_script("$('#reservations-booking-date').val('" + date + "').trigger('change')")
  end
end
