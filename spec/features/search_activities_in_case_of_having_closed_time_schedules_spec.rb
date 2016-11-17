feature 'Search Activities In Case Of Having Closed Time Schedules', js: true do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
    @bowling = create(:bowling, business: @business,
      start_time: '06:00:00', end_time: '18:00:00' )
    @lane_1 = create(:lane, start_time: '07:00', end_time: '17:00',
      activity: @bowling, interval: 60)
    @lane_2 = create(:lane, start_time: '07:00', end_time: '17:00',
      activity: @bowling, interval: 60)
  end
  include_context 'logged in user'

  context 'closing all day' do
    context 'on specific day' do
      context 'on some reservables' do
        background do
          create(:closed_schedule,
            closed_all_day: true,
            closed_specific_day: true,
            closed_on: '10 Nov 2016',
            closed_all_reservables: false,
            closed_reservables: [@lane_1.id],
            activity: @bowling
          )
        end
        context 'user search on closed day' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '10 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be true
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
            end
          end
        end
        context 'user search on other day' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '12 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
            end
          end
        end
      end
      context 'on all reservables' do
        background do
          create(:closed_schedule,
            closed_all_day: true,
            closed_specific_day: true,
            closed_on: '10 Nov 2016',
            closed_all_reservables: true,
            activity: @bowling
          )
        end
        context 'user search on closed day' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '10 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be true
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be true
                end
              end
            end
          end
        end
        context 'user search on other day' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '12 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
            end
          end
        end
      end
    end

    context 'in every monday and tuesday' do
      context 'on some reservables' do
        background do
          create(:closed_schedule,
            closed_all_day: true,
            closed_specific_day: false,
            closed_days: ['Monday', 'Tuesday'],
            closed_all_reservables: false,
            closed_reservables: [@lane_1.id],
            activity: @bowling
          )
        end

        context 'user search on monday' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '14 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be true
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
            end
          end
        end
        context 'user search on tuesday' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '15 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be true
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
            end
          end
        end
        context 'user search on other day' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '17 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
            end
          end
        end
      end
      context 'on all reservables' do
        background do
          create(:closed_schedule,
            closed_all_day: true,
            closed_specific_day: false,
            closed_days: ['Monday', 'Tuesday'],
            closed_all_reservables: true,
            activity: @bowling
          )
        end
        context 'user search on monday' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '14 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be true
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be true
                end
              end
            end
          end
        end
        context 'user search on other day' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '17 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
            end
          end
        end
      end
    end
  end

  context 'closing on specific time' do
    context 'on specific day' do
      context 'on some reservables' do
        background do
          create(:closed_schedule,
            closed_all_day: false,
            closing_begins_at: '08:00am',
            closing_ends_at: '11:00am',
            closed_specific_day: true,
            closed_on: '10 Nov 2016',
            closed_all_reservables: false,
            closed_reservables: [@lane_1.id],
            activity: @bowling
          )
        end
        context 'user search on closed day' do
          context 'user search on closed time' do
            scenario 'shows correct time slots' do
              travel_to Time.new(2016, 11, 5) do
                visit root_path
                search_activities(booking_date: '10 Nov 2016', booking_time: '10:00am')

                expect(page).to have_content @bowling.name
                within("#reservable_#{@lane_1.id}") do
                  expect(page).to have_content @lane_1.name
                  expect(page).to have_content '07:00'
                  expect(page).to have_content '16:00'
                  all('button.timeslot').each do |button|
                    if ['08:00', '09:00', '10:00'].include? button.text
                      expect(button.disabled?).to be true
                    else
                      expect(button.disabled?).to be false
                    end
                  end
                end
                within("#reservable_#{@lane_2.id}") do
                  expect(page).to have_content @lane_2.name
                  expect(page).to have_content '07:00'
                  expect(page).to have_content '16:00'
                  all('button.timeslot').each do |button|
                    expect(button.disabled?).to be false
                  end
                end
              end
            end
          end
        end
      end
      context 'on all reservables' do
        background do
          create(:closed_schedule,
            closed_all_day: false,
            closing_begins_at: '08:00am',
            closing_ends_at: '11:00am',
            closed_specific_day: true,
            closed_on: '10 Nov 2016',
            closed_all_reservables: true,
            activity: @bowling
          )
        end
        context 'user search on closed day' do
          context 'user search on closed time' do
            scenario 'shows correct time slots' do
              travel_to Time.new(2016, 11, 5) do
                visit root_path
                search_activities(booking_date: '10 Nov 2016', booking_time: '10:00am')

                expect(page).to have_content @bowling.name
                within("#reservable_#{@lane_1.id}") do
                  expect(page).to have_content @lane_1.name
                  expect(page).to have_content '07:00'
                  expect(page).to have_content '16:00'
                  all('button.timeslot').each do |button|
                    if ['08:00', '09:00', '10:00'].include? button.text
                      expect(button.disabled?).to be true
                    else
                      expect(button.disabled?).to be false
                    end
                  end
                end
                within("#reservable_#{@lane_2.id}") do
                  expect(page).to have_content @lane_2.name
                  expect(page).to have_content '07:00'
                  expect(page).to have_content '16:00'
                  all('button.timeslot').each do |button|
                    if ['08:00', '09:00', '10:00'].include? button.text
                      expect(button.disabled?).to be true
                    else
                      expect(button.disabled?).to be false
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    context 'in every monday and friday' do
      context 'on some reservables' do
        background do
          create(:closed_schedule,
            closed_all_day: false,
            closing_begins_at: '08:00am',
            closing_ends_at: '11:00am',
            closed_specific_day: false,
            closed_days: ['Monday', 'Friday'],
            closed_all_reservables: false,
            closed_reservables: [@lane_1.id],
            activity: @bowling
          )
        end
        context 'user search on monday' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '14 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  if ['08:00', '09:00', '10:00'].include? button.text
                    expect(button.disabled?).to be true
                  else
                    expect(button.disabled?).to be false
                  end
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
            end
          end
        end
        context 'user search on friday' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '18 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  if ['08:00', '09:00', '10:00'].include? button.text
                    expect(button.disabled?).to be true
                  else
                    expect(button.disabled?).to be false
                  end
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  expect(button.disabled?).to be false
                end
              end
            end
          end
        end
      end
      context 'on all reservables' do
        background do
          create(:closed_schedule,
            closed_all_day: false,
            closing_begins_at: '08:00am',
            closing_ends_at: '11:00am',
            closed_specific_day: false,
            closed_days: ['Monday', 'Friday'],
            closed_all_reservables: true,
            activity: @bowling
          )
        end
        context 'user search on monday' do
          scenario 'shows correct time slots' do
            travel_to Time.new(2016, 11, 5) do
              visit root_path
              search_activities(booking_date: '14 Nov 2016', booking_time: '10:00am')

              expect(page).to have_content @bowling.name
              within("#reservable_#{@lane_1.id}") do
                expect(page).to have_content @lane_1.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  if ['08:00', '09:00', '10:00'].include? button.text
                    expect(button.disabled?).to be true
                  else
                    expect(button.disabled?).to be false
                  end
                end
              end
              within("#reservable_#{@lane_2.id}") do
                expect(page).to have_content @lane_2.name
                expect(page).to have_content '07:00'
                expect(page).to have_content '16:00'
                all('button.timeslot').each do |button|
                  if ['08:00', '09:00', '10:00'].include? button.text
                    expect(button.disabled?).to be true
                  else
                    expect(button.disabled?).to be false
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  context 'special cases' do
    context 'closing in half an hour' do
      scenario 'shows correct time slots' do
        create(:closed_schedule,
          closed_all_day: false,
          closing_begins_at: '08:30am',
          closing_ends_at: '10:30am',
          closed_specific_day: true,
          closed_on: '7 Nov 2016',
          closed_all_reservables: false,
          closed_reservables: [@lane_1.id],
          activity: @bowling
        )

        travel_to Time.new(2016, 11, 5) do
          visit root_path
          search_activities(booking_date: '7 Nov 2016', booking_time: '8:00am')

          expect(page).to have_content @bowling.name
          within("#reservable_#{@lane_1.id}") do
            expect(page).to have_content @lane_1.name
            expect(page).to have_content '07:00'
            expect(page).to have_content '16:00'
            all('button.timeslot').each do |button|
              if ['08:00', '09:00', '10:00'].include? button.text
                expect(button.disabled?).to be true
              else
                expect(button.disabled?).to be false
              end
            end
          end
          within("#reservable_#{@lane_2.id}") do
            expect(page).to have_content @lane_2.name
            expect(page).to have_content '07:00'
            expect(page).to have_content '16:00'
            all('button.timeslot').each do |button|
              expect(button.disabled?).to be false
            end
          end
        end
      end
    end
    context 'two closed schedule is created' do
      context 'closing on specific time' do
        context 'on specific day' do
          context 'on some reservables' do
            background do
              create(:closed_schedule,
                closed_all_day: false,
                closing_begins_at: '08:00am',
                closing_ends_at: '11:00am',
                closed_specific_day: true,
                closed_on: '10 Nov 2016',
                closed_all_reservables: false,
                closed_reservables: [@lane_1.id],
                activity: @bowling
              )
              create(:closed_schedule,
                closed_all_day: false,
                closing_begins_at: '01:30pm',
                closing_ends_at: '02:30pm',
                closed_specific_day: true,
                closed_on: '10 Nov 2016',
                closed_all_reservables: false,
                closed_reservables: [@lane_1.id],
                activity: @bowling
              )
            end
            context 'user search on closed day' do
              context 'user search on closed time' do
                scenario 'shows correct time slots' do
                  travel_to Time.new(2016, 11, 5) do
                    visit root_path
                    search_activities(booking_date: '10 Nov 2016', booking_time: '10:00am')

                    expect(page).to have_content @bowling.name
                    within("#reservable_#{@lane_1.id}") do
                      expect(page).to have_content @lane_1.name
                      expect(page).to have_content '07:00'
                      expect(page).to have_content '16:00'
                      all('button.timeslot').each do |button|
                        if ['08:00', '09:00', '10:00', '13:00', '14:00'].include? button.text
                          expect(button.disabled?).to be true
                        else
                          expect(button.disabled?).to be false
                        end
                      end
                    end
                    within("#reservable_#{@lane_2.id}") do
                      expect(page).to have_content @lane_2.name
                      expect(page).to have_content '07:00'
                      expect(page).to have_content '16:00'
                      all('button.timeslot').each do |button|
                        expect(button.disabled?).to be false
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    context 'user search on time that before open hour business' do
      scenario 'shows correct time slots' do
        create(:closed_schedule,
          closed_all_day: false,
          closing_begins_at: '08:30am',
          closing_ends_at: '10:30am',
          closed_specific_day: true,
          closed_on: '7 Nov 2016',
          closed_all_reservables: false,
          closed_reservables: [@lane_1.id],
          activity: @bowling
        )

        travel_to Time.new(2016, 11, 5) do
          visit root_path
          search_activities(booking_date: '7 Nov 2016', booking_time: '2:00am')

          expect(page).to have_content @bowling.name
          within("#reservable_#{@lane_1.id}") do
            expect(page).to have_content @lane_1.name
            expect(page).to have_content '07:00'
            expect(page).to have_content '16:00'
            all('button.timeslot').each do |button|
              if ['08:00', '09:00', '10:00'].include? button.text
                expect(button.disabled?).to be true
              else
                expect(button.disabled?).to be false
              end
            end
          end
          within("#reservable_#{@lane_2.id}") do
            expect(page).to have_content @lane_2.name
            expect(page).to have_content '07:00'
            expect(page).to have_content '16:00'
            all('button.timeslot').each do |button|
              expect(button.disabled?).to be false
            end
          end
        end
      end
    end
  end
end
