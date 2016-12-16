feature 'Selection Summary Popup', :js do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  describe 'Bowlings exist' do
    background do
      @bowling = create(:bowling, business: @business,
        start_time: '07:00', end_time: '18:00')
    end
    context 'has one lane' do
      background do
        @lane = create(
          :lane,
          start_time: '08:00',
          end_time: '17:00',
          activity: @bowling
        )
      end
      context 'unselecting timeslot' do
        scenario 'hides a popup' do
          visit root_path
          search_activities(booking_time: '8:00am')
          click_button '08:00'
          click_button '08:00'
          expect(page).to_not have_content "You've just selected"
        end
        context 'right most booked timeslot is the last time slot in lane' do
          scenario 'shows correct message' do
            visit root_path
            search_activities(booking_time: '8:00am')
            click_button '16:00'
            click_button '08:00'
            click_button '08:00'
            expect(page).to have_content "You've just selected 60 minutes for Lane 1"
          end
        end
        context 'the next right most booked was disabled' do
          background do
            order = create(:order, activity: @bowling)
            create(:booking, start_time: '16:00:00', end_time: '17:00:00',
              booking_date: '2016-01-02', order: order, reservable: @lane
            )
          end
          scenario 'shows correct message' do
            travel_to Time.new(2016, 1, 2) do
              visit root_path
              search_activities(booking_time: '2:00pm')
              click_button '15:00'
              click_button '14:00'
              click_button '14:00'
            end
            expect(page).to have_content
              "You've selected 60 minutes for Lane 1, The next time slot is currently unavailable"
          end
        end
        context 'there are some timeslots left in lane after unselecting a timeslot' do
          scenario 'shows correct message' do
            visit root_path
            search_activities(booking_time: '8:00am')
            click_button '09:00'
            click_button '10:00'
            click_button '12:00'
            click_button '13:00'
            click_button '09:00'
            expect(page).to have_content
              "You've just selected 180 minutes for Lane 1, click here to add 60 more minutes"
          end
          context 'selecting the last time slot in lane' do
            scenario 'selects the right most available timeslot' do
              visit root_path
              search_activities(booking_time: '8:00am')
              click_button '09:00'
              click_button '10:00'
              click_button '12:00'
              click_button '13:00'
              click_button '09:00'
              click_link 'here'
              slot_1 = page.find("#timeslot-1-1-2 i")
              slot_2 = page.find("#timeslot-1-1-3 i")
              slot_3 = page.find("#timeslot-1-1-5 i")
              slot_4 = page.find("#timeslot-1-1-6 i")
              slot_5 = page.find("#timeslot-1-1-7 i")
              expect(slot_1[:class].include?("fa-check")).to be false
              expect(slot_2[:class].include?("fa-check")).to be true
              expect(slot_3[:class].include?("fa-check")).to be true
              expect(slot_4[:class].include?("fa-check")).to be true
              expect(slot_5[:class].include?("fa-check")).to be true
              expect(page).to have_content
                "You've just selected 240 minutes for Lane 1, click here to add 60 more minutes"
            end
          end
        end
      end
      context 'selecting timeslot' do
        scenario 'shows correct message' do
          visit root_path
          search_activities(booking_time: '8:00am')
          click_button '08:00'
          expect(page).to have_content
            "You've just selected 60 minutes for Lane 1, click here to add 60 more minutes"
        end
        context 'selecting the last time slot in lane' do
          scenario 'shows correct message' do
            visit root_path
            search_activities(booking_time: '8:00am')
            click_button '16:00'
            expect(page).to have_content "You've just selected 60 minutes for Lane 1"
          end
        end
        context 'the next time slot was disabled' do
          background do
            order = create(:order, activity: @bowling)
            create(:booking, start_time: '16:00:00', end_time: '17:00:00',
              booking_date: '2016-01-02', order: order, reservable: @lane
            )
          end
          scenario 'shows correct message' do
            travel_to Time.new(2016, 1, 2) do
              visit root_path
              search_activities(booking_time: '3:00pm')
              click_button '15:00'
            end
            expect(page).to have_content
              "You've just selected 60 minutes for Lane 1, The next time slot is currently unavailable"
          end
        end
        context 'the next time slot was booked' do
          scenario 'shows correct message' do
            visit root_path
            search_activities(booking_time: '8:00am')
            click_button '14:00'
            click_button '13:00'
            expect(page).to have_content
              "You've just selected 120 minutes for Lane 1, The next time slot is currently booked"
          end
        end
        context 'selecting one more timeslot in lane' do
          scenario 'selects next time slot' do
            visit root_path
            search_activities(booking_time: '8:00am')
            click_button '08:00'
            click_link 'here'
            first_slot = page.find("#timeslot-1-1-1 i")
            second_slot = page.find("#timeslot-1-1-2 i")
            expect(first_slot[:class].include?("fa-check")).to be true
            expect(second_slot[:class].include?("fa-check")).to be true
            expect(page).to have_content
              "You've just selected 120 minutes for Lane 1, click here to add 60 more minutes"
          end
        end
      end
    end
  end
end
