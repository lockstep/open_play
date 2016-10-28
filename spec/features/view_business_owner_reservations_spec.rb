feature 'View Business Owner Reservations', :js do
  background do
    @user = create(:user)
    business = create(:business, user: @user)

    @bowling = create(:bowling, business: business)
    @lane_one = create(:lane, name: 'lane_one', activity: @bowling,
      weekday_price: 5, per_person_weekday_price: 10)
    @lane_two = create(:lane, name: 'lane_two', activity: @bowling,
      weekday_price: 10, per_person_weekday_price: 15)

    @laser_tag = create(:laser_tag, business: business)
    @room_one = create(:room, name: 'room_one', activity: @laser_tag,
      weekend_price: 5, per_person_weekend_price: 10)
    @room_two = create(:room, name: 'room_two', activity: @laser_tag,
      weekend_price: 10, per_person_weekend_price: 20)
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
      order_2 = create(:order, user: @user_2, activity: @laser_tag)
      @booking_3 = create(:booking, order: order_2, reservable: @room_one,
        start_time: '10:00:00', end_time: '11:00:00', booking_date: '2016-10-22',
        number_of_players: 4)
      @booking_4 = create(:booking, order: order_2, reservable: @room_two,
        start_time: '14:00:00', end_time: '15:00:00', booking_date: '2016-10-22',
        number_of_players: 5)
    end

    context 'checking bowling activity' do
      context 'booking_date and system date are the same' do
        scenario 'shows reservations' do
          travel_to Time.new(2016, 10, 13) do
            visit root_path
            click_link 'Manage Business'
            within("#activity_#{@bowling.id}") do
              click_link 'View reservations'
            end
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
          expect(page).to have_content '$ 80.0'

          expect(page).to_not have_content @laser_tag.name
          expect(page).to_not have_content @room_one.name
          expect(page).to_not have_content @room_two.name
        end

        scenario 'export reservations as CSV' do
          travel_to Time.new(2016, 10, 13) do
            visit root_path
            click_link 'Manage Business'
            within("#activity_#{@bowling.id}") do
              click_link 'View reservations'
            end
          end

          click_link 'Export to CSV'
          expect(page.status_code).to eq 200
          expect(page.response_headers['Content-Type']).to eq "text/csv"
        end

        scenario 'export reservations as XLS' do
          travel_to Time.new(2016, 10, 13) do
            visit root_path
            click_link 'Manage Business'
            within("#activity_#{@bowling.id}") do
              click_link 'View reservations'
            end
          end

          click_link 'Export to XLS'
          expect(page.status_code).to eq 200
          expect(page.response_headers['Content-Type']).to eq "application/xls"
        end
      end

      context 'booking_date and system date are not the same' do
        scenario 'does not show reservations' do
          travel_to Time.new(2016, 10, 14) do
            visit root_path
            click_link 'Manage Business'
            within("#activity_#{@bowling.id}") do
              click_link 'View reservations'
            end
          end
          expect(page).to_not have_content @bowling.name
          expect(page).to_not have_content @lane_one.name
          expect(page).to_not have_content @laser_tag.name
          expect(page).to_not have_content @room_one.name
        end

        context 'select a booking_date from calendar' do
          scenario 'shows reservations' do
            travel_to Time.new(2016, 10, 14) do
              visit root_path
              click_link 'Manage Business'
              within("#activity_#{@bowling.id}") do
                click_link 'View reservations'
              end
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
            expect(page).to have_content '$ 80.0'

            expect(page).to_not have_content @laser_tag.name
            expect(page).to_not have_content @room_one.name
            expect(page).to_not have_content @room_two.name
          end
        end
      end
    end

    context 'checking laser_tag activity' do
      context 'booking_date and system date are the same' do
        scenario 'shows reservations' do
          travel_to Time.new(2016, 10, 22) do
            visit root_path
            click_link 'Manage Business'
            within("#activity_#{@laser_tag.id}") do
              click_link 'View reservations'
            end
          end

          expect(page).to have_content @laser_tag.name
          expect(page).to have_content @room_one.name
          expect(page).to have_content '10:00 AM - 11:00 AM'
          expect(page).to have_content '22 October'
          expect(find("#number_of_people_from_booking_#{@booking_3.id}")).to have_content 4
          expect(page).to have_content @room_two.name
          expect(page).to have_content '02:00 PM - 03:00 PM'
          expect(page).to have_content '22 October'
          expect(find("#number_of_people_from_booking_#{@booking_4.id}")).to have_content 5
          expect(page).to have_content '$ 155.0'

          expect(page).to_not have_content @bowling.name
          expect(page).to_not have_content @lane_one.name
          expect(page).to_not have_content @lane_two.name
        end
      end

      context 'booking_date and system date are not the same' do
        scenario 'does not show reservations' do
          travel_to Time.new(2016, 10, 13) do
            visit root_path
            click_link 'Manage Business'
            within("#activity_#{@laser_tag.id}") do
              click_link 'View reservations'
            end
          end

          expect(page).to_not have_content @laser_tag.name
          expect(page).to_not have_content @room_one.name
          expect(page).to_not have_content @bowling.name
          expect(page).to_not have_content @lane_one.name
        end

        context 'select a booking_date from calendar' do
          scenario 'shows reservations' do
            travel_to Time.new(2016, 10, 13) do
              visit root_path
              click_link 'Manage Business'
              within("#activity_#{@laser_tag.id}") do
                click_link 'View reservations'
              end
              select_a_booking_date('2016-10-22')
            end

            expect(page).to have_content @laser_tag.name
            expect(page).to have_content @room_one.name
            expect(page).to have_content '10:00 AM - 11:00 AM'
            expect(page).to have_content '22 October'
            expect(find("#number_of_people_from_booking_#{@booking_3.id}")).to have_content 4
            expect(page).to have_content @room_two.name
            expect(page).to have_content '02:00 PM - 03:00 PM'
            expect(page).to have_content '22 October'
            expect(find("#number_of_people_from_booking_#{@booking_4.id}")).to have_content 5
            expect(page).to have_content '$ 155.0'

            expect(page).to_not have_content @bowling.name
            expect(page).to_not have_content @lane_one.name
            expect(page).to_not have_content @lane_two.name
          end
        end
      end
    end
  end

  def select_a_booking_date(date)
    page.execute_script("$('#reservations-booking-date').val('" + date + "').trigger('change')")
  end
end
