feature 'Create Closed Schedule', js: true do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  context 'an activity exist' do
    before { @activity = create(:bowling, business: @business) }
    context 'a lane exist' do
      before do
        @lane_1 = create(:lane, activity: @activity, name: 'lane one')
        @lane_2 = create(:lane, activity: @activity, name: 'lane two')
      end
      context 'user create closing time' do
        scenario 'does not show closing time' do
          navigate_to_closing_time
          expect(page).to have_content "#{@activity.name} Closing Time"
          expect(page).to have_content 'There is no closing time'
        end
        context 'All day on specific day' do
          scenario 'creates closing time successfully' do
            travel_to Time.new(2016, 11, 5) do
              navigate_to_closing_time
              fill_in 'closed_schedule[label]', with: 'Meeting in Korea'
              choose 'specific-day-checkbox'
              fill_in 'closed_schedule[closed_on]', with: '6 Nov 2016'
              choose 'all-day-checkbox'
              choose 'all-reservable-checkbox'
              click_button 'Submit'
            end
            expect(page).to have_content 'Closing time scheduled successfully.'
            expect(current_path).to eq activity_closed_schedules_path(@activity)
            expect(page).to have_content 'Meeting in Korea'
            expect(page).to have_content '6 Nov 2016'
            expect(page).to have_content 'All day'
            expect(page).to have_content 'All reservables'
            expect(page).to have_selector '#destroy-schedule-1'
          end
        end
        context 'All day in every monday' do
          context 'a day is checked' do
            scenario 'creates closing time successfully' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_closing_time
                fill_in 'closed_schedule[label]', with: 'Meeting in Korea'
                choose 'every-x-checkbox'
                check 'closed_schedule_closed_days_monday'
                choose 'all-day-checkbox'
                choose 'all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Closing time scheduled successfully.'
              expect(current_path).to eq activity_closed_schedules_path(@activity)
              expect(page).to have_content 'Meeting in Korea'
              expect(page).to have_content 'Every Monday'
              expect(page).to have_content 'All day'
              expect(page).to have_content 'All reservables'
              expect(page).to have_selector '#destroy-schedule-1'
            end
          end
          context 'a day is not checked' do
            scenario 'does not create closing time' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_closing_time
                fill_in 'closed_schedule[label]', with: 'Meeting in Korea'
                choose 'every-x-checkbox'
                choose 'all-day-checkbox'
                choose 'all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Closed days must be selected'
              expect(current_path).to eq activity_closed_schedules_path(@activity)
              expect(page).to_not have_content 'Closing time scheduled successfully.'
              expect(page).to_not have_content 'Meeting in Korea'
              expect(page).to_not have_selector '#destroy-schedule-1'
            end
          end
        end
        context 'All day in every monday and sunday' do
          context 'a day is checked' do
            scenario 'creates closing time successfully' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_closing_time
                fill_in 'closed_schedule[label]', with: 'Meeting in Korea'
                choose 'every-x-checkbox'
                check 'closed_schedule_closed_days_monday'
                check 'closed_schedule_closed_days_sunday'
                choose 'all-day-checkbox'
                choose 'all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Closing time scheduled successfully.'
              expect(current_path).to eq activity_closed_schedules_path(@activity)
              expect(page).to have_content 'Meeting in Korea'
              expect(page).to have_content 'Every Monday, Sunday'
              expect(page).to have_content 'All day'
              expect(page).to have_content 'All reservables'
              expect(page).to have_selector '#destroy-schedule-1'
            end
          end
        end
        context 'on specific time and specific day' do
          context 'closing_ends_at is after closing_begins_at' do
            scenario 'creates closing time successfully' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_closing_time
                fill_in 'closed_schedule[label]', with: 'Meeting in Korea'
                choose 'specific-day-checkbox'
                fill_in 'closed_schedule[closed_on]', with: '6 Nov 2016'
                choose 'specific-time-range-checkbox'
                fill_in 'closed_schedule[closing_begins_at]', with: '10:00am'
                fill_in 'closed_schedule[closing_ends_at]', with: '11:00am'
                choose 'all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Closing time scheduled successfully.'
              expect(current_path).to eq activity_closed_schedules_path(@activity)
              expect(page).to have_content 'Meeting in Korea'
              expect(page).to have_content '6 Nov 2016'
              expect(page).to have_content '10:00 AM - 11:00 AM'
              expect(page).to have_content 'All reservables'
              expect(page).to have_selector '#destroy-schedule-1'
            end
          end
          context 'closing_ends_at is before closing_begins_at' do
            scenario 'does not create closing time' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_closing_time
                fill_in 'closed_schedule[label]', with: 'Meeting in Korea'
                choose 'specific-day-checkbox'
                fill_in 'closed_schedule[closed_on]', with: '6 Nov 2016'
                choose 'specific-time-range-checkbox'
                fill_in 'closed_schedule[closing_begins_at]', with: '12:00pm'
                fill_in 'closed_schedule[closing_ends_at]', with: '11:00am'
                choose 'all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Closing ends at must be after 12:00 PM'
              expect(current_path).to eq activity_closed_schedules_path(@activity)
              expect(page).to_not have_content 'Closing time scheduled successfully.'
              expect(page).to_not have_content 'Meeting in Korea'
              expect(page).to_not have_selector '#destroy-schedule-1'
            end
          end
        end
        context 'on specific time and in every monday' do
          scenario 'creates closing time successfully' do
            travel_to Time.new(2016, 11, 5) do
              navigate_to_closing_time
              fill_in 'closed_schedule[label]', with: 'Meeting in Korea'
              choose 'every-x-checkbox'
              check 'closed_schedule_closed_days_monday'
              choose 'specific-time-range-checkbox'
              fill_in 'closed_schedule[closing_begins_at]', with: '10:00am'
              fill_in 'closed_schedule[closing_ends_at]', with: '11:00am'
              choose 'all-reservable-checkbox'
              click_button 'Submit'
            end
            expect(page).to have_content 'Closing time scheduled successfully.'
            expect(current_path).to eq activity_closed_schedules_path(@activity)
            expect(page).to have_content 'Meeting in Korea'
            expect(page).to have_content 'Every Monday'
            expect(page).to have_content '10:00 AM - 11:00 AM'
            expect(page).to have_content 'All reservables'
            expect(page).to have_selector '#destroy-schedule-1'
          end
          context 'closing_ends_at is before closing_begins_at' do
            scenario 'does not create closing time' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_closing_time
                fill_in 'closed_schedule[label]', with: 'Meeting in Korea'
                choose 'every-x-checkbox'
                check 'closed_schedule_closed_days_monday'
                choose 'specific-time-range-checkbox'
                fill_in 'closed_schedule[closing_begins_at]', with: '12:00pm'
                fill_in 'closed_schedule[closing_ends_at]', with: '11:00am'
                choose 'all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Closing ends at must be after 12:00 PM'
              expect(current_path).to eq activity_closed_schedules_path(@activity)
              expect(page).to_not have_content 'Closing time scheduled successfully.'
              expect(page).to_not have_content 'Meeting in Korea'
              expect(page).to_not have_selector '#destroy-schedule-1'
            end
          end
          context 'a day is not checked' do
            scenario 'does not create closing time' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_closing_time
                fill_in 'closed_schedule[label]', with: 'Meeting in Korea'
                choose 'every-x-checkbox'
                choose 'specific-time-range-checkbox'
                fill_in 'closed_schedule[closing_begins_at]', with: '11:00am'
                fill_in 'closed_schedule[closing_ends_at]', with: '12:00pm'
                choose 'all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Closed days must be selected'
              expect(current_path).to eq activity_closed_schedules_path(@activity)
              expect(page).to_not have_content 'Closing time scheduled successfully.'
              expect(page).to_not have_content 'Meeting in Korea'
              expect(page).to_not have_selector '#destroy-schedule-1'
            end
          end
        end
        context 'on specific time, specific day and a reservable' do
          scenario 'creates closing time successfully' do
            travel_to Time.new(2016, 11, 5) do
              navigate_to_closing_time
              fill_in 'closed_schedule[label]', with: 'Meeting in Korea'
              choose 'specific-day-checkbox'
              fill_in 'closed_schedule[closed_on]', with: '6 Nov 2016'
              choose 'specific-time-range-checkbox'
              fill_in 'closed_schedule[closing_begins_at]', with: '10:00am'
              fill_in 'closed_schedule[closing_ends_at]', with: '11:00am'
              choose 'specific-reservable-checkbox'
              check "closed_schedule_closed_reservables_#{@lane_1.id}"
              check "closed_schedule_closed_reservables_#{@lane_2.id}"
              click_button 'Submit'
            end
            expect(page).to have_content 'Closing time scheduled successfully.'
            expect(current_path).to eq activity_closed_schedules_path(@activity)
            expect(page).to have_content 'Meeting in Korea'
            expect(page).to have_content '6 Nov 2016'
            expect(page).to have_content '10:00 AM - 11:00 AM'
            expect(page).to have_content 'lane one, lane two'
            expect(page).to have_selector '#destroy-schedule-1'
          end

          context 'a reservable is not checked' do
            scenario 'does not create closing time' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_closing_time
                fill_in 'closed_schedule[label]', with: 'Meeting in Korea'
                choose 'specific-day-checkbox'
                fill_in 'closed_schedule[closed_on]', with: '6 Nov 2016'
                choose 'specific-time-range-checkbox'
                fill_in 'closed_schedule[closing_begins_at]', with: '10:00am'
                fill_in 'closed_schedule[closing_ends_at]', with: '11:00am'
                choose 'specific-reservable-checkbox'
                click_button 'Submit'
              end

              expect(page).to have_content 'Closed reservables must be selected'
              expect(current_path).to eq activity_closed_schedules_path(@activity)
              expect(page).to_not have_content 'Closing time scheduled successfully.'
              expect(page).to_not have_content 'Meeting in Korea'
              expect(page).to_not have_selector '#destroy-schedule-1'
            end
          end
        end
      end
    end
  end

  def navigate_to_closing_time
    visit root_path
    click_link 'Manage Business'
    click_link 'Edit'
    click_link 'Closing Time'
  end
end
