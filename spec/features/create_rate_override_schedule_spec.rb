feature 'Create Rate Override Schedule', js: true do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  context 'an activity exist' do
    before do
      @activity = create(:bowling, business: @business)
    end
    context 'a lane exist' do
      before do
        @lane_1 = create(:lane, activity: @activity, name: 'lane one')
        @lane_2 = create(:lane, activity: @activity, name: 'lane two')
      end

      context 'user is going to create rate override schedule' do
        scenario 'sees nothing' do
          navigate_to_rate_override_schedule
          expect(page).to have_content "#{@activity.name} Rate Override Schedule"
          expect(page).to have_content 'There is no rate override schedule'
        end
        context 'All day on specific day' do
          scenario 'creates a rate override schedule successfully' do
            travel_to Time.new(2016, 11, 5) do
              navigate_to_rate_override_schedule
              fill_in 'rate_override_schedule[label]', with: 'New Year Promotion'
              fill_in 'rate_override_schedule[price]', with: '15'
              fill_in 'rate_override_schedule[per_person_price]', with: '20'
              choose 'rate-specific-day-checkbox'
              fill_in 'rate_override_schedule[overridden_on]', with: '6 Nov 2016'
              choose 'rate-all-day-checkbox'
              choose 'rate-all-reservable-checkbox'
              click_button 'Submit'
            end
            expect(page).to have_content 'Rate override schedule was created'
            expect(current_path).to eq activity_rate_override_schedules_path(@activity)
            expect(page).to have_content 'New Year Promotion'
            expect(page).to have_content '6 Nov 2016'
            expect(page).to have_content 'All day'
            expect(page).to have_content 'All reservables'
            expect(page).to have_content '$ 15'
            expect(page).to have_content '$ 20'
            expect(page).to have_selector '#destroy-rate-override-schedule-1'
          end
        end
        context 'All day in every monday' do
          context 'a day is checked' do
            scenario 'creates a rate override schedule successfully' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_rate_override_schedule
                fill_in 'rate_override_schedule[label]', with: 'New Year Promotion'
                fill_in 'rate_override_schedule[price]', with: '15'
                fill_in 'rate_override_schedule[per_person_price]', with: '20'
                choose 'rate-every-x-checkbox'
                check 'rate_override_schedule_monday'
                choose 'rate-all-day-checkbox'
                choose 'rate-all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Rate override schedule was created'
              expect(current_path).to eq activity_rate_override_schedules_path(@activity)
              expect(page).to have_content 'New Year Promotion'
              expect(page).to have_content 'Every Monday'
              expect(page).to have_content 'All day'
              expect(page).to have_content 'All reservables'
              expect(page).to have_content '$ 15'
              expect(page).to have_content '$ 20'
              expect(page).to have_selector '#destroy-rate-override-schedule-1'
            end
          end
          context 'a day is not checked' do
            scenario 'does not create a rate override schedule' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_rate_override_schedule
                fill_in 'rate_override_schedule[label]', with: 'New Year Promotion'
                fill_in 'rate_override_schedule[price]', with: '15'
                fill_in 'rate_override_schedule[per_person_price]', with: '20'
                choose 'rate-every-x-checkbox'
                choose 'rate-all-day-checkbox'
                choose 'rate-all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Overridden days must be selected'
              expect(current_path).to eq activity_rate_override_schedules_path(@activity)
              expect(page).to_not have_content 'Rate override schedule was created'
              expect(page).to_not have_content 'New Year Promotion'
            end
          end
        end
        context 'All day in every monday and sunday' do
          context 'a day is checked' do
            scenario 'creates a rate override schedule successfully' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_rate_override_schedule
                fill_in 'rate_override_schedule[label]', with: 'New Year Promotion'
                fill_in 'rate_override_schedule[price]', with: '15'
                fill_in 'rate_override_schedule[per_person_price]', with: '20'
                choose 'rate-every-x-checkbox'
                check 'rate_override_schedule_monday'
                check 'rate_override_schedule_sunday'
                choose 'rate-all-day-checkbox'
                choose 'rate-all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Rate override schedule was created'
              expect(current_path).to eq activity_rate_override_schedules_path(@activity)
              expect(page).to have_content 'New Year Promotion'
              expect(page).to have_content 'Every Monday, Sunday'
              expect(page).to have_content 'All day'
              expect(page).to have_content 'All reservables'
              expect(page).to have_content '$ 15'
              expect(page).to have_content '$ 20'
              expect(page).to have_selector '#destroy-rate-override-schedule-1'
            end
          end
        end
        context 'on specific time and specific day' do
          context 'overriding_ends_at is after overriding_begins_at' do
            scenario 'creates a rate override schedule successfully' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_rate_override_schedule
                fill_in 'rate_override_schedule[label]', with: 'New Year Promotion'
                fill_in 'rate_override_schedule[price]', with: '15'
                fill_in 'rate_override_schedule[per_person_price]', with: '20'
                choose 'rate-specific-day-checkbox'
                fill_in 'rate_override_schedule[overridden_on]', with: '6 Nov 2016'
                choose 'rate-specific-time-range-checkbox'
                fill_in 'rate_override_schedule[overriding_begins_at]', with: '10:00am'
                fill_in 'rate_override_schedule[overriding_ends_at]', with: '11:00am'
                choose 'rate-all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Rate override schedule was created'
              expect(current_path).to eq activity_rate_override_schedules_path(@activity)
              expect(page).to have_content 'New Year Promotion'
              expect(page).to have_content '6 Nov 2016'
              expect(page).to have_content '10:00 AM - 11:00 AM'
              expect(page).to have_content 'All reservables'
              expect(page).to have_content '$ 15'
              expect(page).to have_content '$ 20'
              expect(page).to have_selector '#destroy-rate-override-schedule-1'
            end
          end
          context 'overriding_ends_at is before overriding_begins_at' do
            scenario 'does not create a rate override schedule successfully' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_rate_override_schedule
                fill_in 'rate_override_schedule[label]', with: 'New Year Promotion'
                fill_in 'rate_override_schedule[price]', with: '15'
                fill_in 'rate_override_schedule[per_person_price]', with: '20'
                choose 'rate-specific-day-checkbox'
                fill_in 'rate_override_schedule[overridden_on]', with: '6 Nov 2016'
                choose 'rate-specific-time-range-checkbox'
                fill_in 'rate_override_schedule[overriding_begins_at]', with: '12:00pm'
                fill_in 'rate_override_schedule[overriding_ends_at]', with: '10:00am'
                choose 'rate-all-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Overriding ends at must be after 12:00 PM'
              expect(page).to_not have_content 'Rate override schedule was created'
              expect(page).to_not have_content 'New Year Promotion'
              expect(current_path).to eq activity_rate_override_schedules_path(@activity)
            end
          end
        end
        context 'on specific time and in every monday' do
          scenario 'creates a rate override schedule successfully' do
            travel_to Time.new(2016, 11, 5) do
              navigate_to_rate_override_schedule
              fill_in 'rate_override_schedule[label]', with: 'New Year Promotion'
              fill_in 'rate_override_schedule[price]', with: '15'
              fill_in 'rate_override_schedule[per_person_price]', with: '20'

              choose 'rate-every-x-checkbox'
              check 'rate_override_schedule_monday'

              choose 'rate-specific-time-range-checkbox'
              fill_in 'rate_override_schedule[overriding_begins_at]', with: '10:00am'
              fill_in 'rate_override_schedule[overriding_ends_at]', with: '11:00am'
              choose 'rate-all-reservable-checkbox'
              click_button 'Submit'
            end
            expect(page).to have_content 'Rate override schedule was created'
            expect(current_path).to eq activity_rate_override_schedules_path(@activity)
            expect(page).to have_content 'New Year Promotion'
            expect(page).to have_content 'Every Monday'
            expect(page).to have_content '10:00 AM - 11:00 AM'
            expect(page).to have_content 'All reservables'
            expect(page).to have_content '$ 15'
            expect(page).to have_content '$ 20'
            expect(page).to have_selector '#destroy-rate-override-schedule-1'
          end
        end

        context 'on specific time, specific day and a reservable' do
          scenario 'creates a rate override schedule successfully' do
            travel_to Time.new(2016, 11, 5) do
              navigate_to_rate_override_schedule
              fill_in 'rate_override_schedule[label]', with: 'New Year Promotion'
              fill_in 'rate_override_schedule[price]', with: '15'
              fill_in 'rate_override_schedule[per_person_price]', with: '20'
              choose 'rate-specific-day-checkbox'
              fill_in 'rate_override_schedule[overridden_on]', with: '6 Nov 2016'
              choose 'rate-specific-time-range-checkbox'
              fill_in 'rate_override_schedule[overriding_begins_at]', with: '10:00am'
              fill_in 'rate_override_schedule[overriding_ends_at]', with: '11:00am'
              choose 'rate-specific-reservable-checkbox'
              check 'rate-override-schedule-overridden-reservables-1'
              click_button 'Submit'
            end
            expect(page).to have_content 'Rate override schedule was created'
            expect(current_path).to eq activity_rate_override_schedules_path(@activity)
            expect(page).to have_content 'New Year Promotion'
            expect(page).to have_content '6 Nov 2016'
            expect(page).to have_content '10:00 AM - 11:00 AM'
            expect(page).to have_content 'lane one'
            expect(page).to have_content '$ 15'
            expect(page).to have_content '$ 20'
            expect(page).to have_selector '#destroy-rate-override-schedule-1'
          end
          context 'a reservable is not checked' do
            scenario 'does not create a rate override schedule successfully' do
              travel_to Time.new(2016, 11, 5) do
                navigate_to_rate_override_schedule
                fill_in 'rate_override_schedule[label]', with: 'New Year Promotion'
                fill_in 'rate_override_schedule[price]', with: '15'
                fill_in 'rate_override_schedule[per_person_price]', with: '20'
                choose 'rate-specific-day-checkbox'
                fill_in 'rate_override_schedule[overridden_on]', with: '6 Nov 2016'
                choose 'rate-specific-time-range-checkbox'
                fill_in 'rate_override_schedule[overriding_begins_at]', with: '10:00am'
                fill_in 'rate_override_schedule[overriding_ends_at]', with: '11:00am'
                choose 'rate-specific-reservable-checkbox'
                click_button 'Submit'
              end
              expect(page).to have_content 'Overridden reservables must be selected'
              expect(page).to_not have_content 'Rate override schedule was created'
              expect(page).to_not have_content 'New Year Promotion'
              expect(current_path).to eq activity_rate_override_schedules_path(@activity)
            end
          end
        end
      end
    end
  end

  def navigate_to_rate_override_schedule
    visit root_path
    click_link 'Manage Business'
    click_link 'Edit'
    click_link 'Rate Override Schedule'
  end
end
