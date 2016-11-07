feature 'Search Closing Time Activities', js: true do

  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  describe 'A lane exists' do
    background do
      @bowling = create(:bowling, business: @business)
      @lane = create(:lane,
        start_time: '08:00',
        end_time: '17:00',
        activity: @bowling
      )
    end

    context 'An activity is scheduled to close all day' do
      context 'on specific day' do
        background do
          create(:closed_schedule,
            closed_all_day: true,
            closed_specific_day: true,
            closed_on: '10 Nov 2016'
          )
        end

        scenario 'shows the appropiate message' do
          travel_to Time.new(2016, 11, 5) do
            visit root_path
            search_activities(booking_date: '10 Nov 2016', booking_time: '10:00am')
            expect(page).to have_content 'No results found'
          end
        end
      end

      context 'in every monday and tuesday' do
        background do
          create(:closed_schedule,
            closed_all_day: true,
            closed_specific_day: false,
            closed_days: ['monday', 'tuesday']
          )
        end

        context 'searchs on monday' do
          scenario 'shows the appropiate message' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '14 Nov 2016', booking_time: '10:00am')
              expect(page).to have_content 'No results found'
            end
          end
        end

        context 'searchs on tuesday' do
          scenario 'shows the appropiate message' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '15 Nov 2016', booking_time: '10:00am')
              expect(page).to have_content 'No results found'
            end
          end
        end
      end
    end

    context 'An activity is scheduled to close on specific time' do
      context 'on specific day' do
        background do
          create(:closed_schedule,
            closed_all_day: false,
            closing_begins_at: '10:00am',
            closing_ends_at: '11:00am',
            closed_specific_day: true,
            closed_on: '7 Nov 2016'
          )
        end

        context 'searchs on monday' do
          scenario 'shows the appropiate message' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '7 Nov 2016', booking_time: '10:00am')
              expect(page).to have_button('10:00', disabled: true)
              expect(page).to have_button('11:00', disabled: false)
            end
          end
        end
      end

      context 'in every monday' do
        background do
          create(:closed_schedule,
            closed_all_day: false,
            closing_begins_at: '10:00am',
            closing_ends_at: '11:00am',
            closed_specific_day: false,
            closed_days: ['monday']
          )
        end

        context 'searchs on monday' do
          scenario 'shows the appropiate message' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '12 Nov 2016', booking_time: '10:00am')
              expect(page).to have_button('10:00', disabled: true)
              expect(page).to have_button('11:00', disabled: false)
            end
          end
        end
      end
    end
  end
end
