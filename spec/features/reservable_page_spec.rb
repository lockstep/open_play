feature 'Reservable Page' do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  describe '#display' do
    context 'Bowling exists' do
      background do
        @bowling = create(:bowling, business: @business)
        visit root_path
        click_link 'Manage Business'
      end

      scenario 'display default times the same as the activity times' do
        click_link 'Add a Lane'
        expect(find_field('reservable_start_time').value).to match '09:00 AM'
        expect(find_field('reservable_end_time').value).to match '05:00 PM'
      end

      context 'Reservable type as Lane' do
        background do
          ReservableOption.create(name: 'bumper', reservable_type: 'Lane')
          ReservableOption.create(name: 'handicap_accessible', reservable_type: 'Lane')
          click_link 'Add a Lane'
        end

        scenario 'display possible options for Lane' do
          expect(page).to have_content 'Bumper'
          expect(page).to have_content 'Handicap accessible'
        end
      end
    end
  end

  describe '#create' do
    context 'Laser tag exists' do
      background do
        @laser_tag = create(:laser_tag, business: @business)
      end

      context 'valid params' do
        scenario 'creates a correct type of reservable successfully' do
          navigate_to_add_a_room
          complete_room_form

          expect(page).to have_content 'Room was successfully added'
        end
      end
      context 'invalid params' do
        context 'the interval is invalid' do
          scenario 'does not create a reservable' do
            navigate_to_add_a_room
            complete_room_form(interval: '60 min')

            expect(page).to have_content 'is not a number'
          end
        end

        context 'the end_time is invalid' do
          scenario 'does not create a reservable' do
            navigate_to_add_a_room
            complete_room_form(end_time: '09:00')

            expect(page).to have_content 'must be after the start time'
          end
        end

        context 'the maximum_players is invalid' do
          context 'the maximum_players is a string' do
            scenario 'does not create a reservable' do
              navigate_to_add_a_room
              complete_room_form(maximum_players: 'hello')

              expect(page).to have_content 'is not a number'
            end
          end

          context 'the maximum_players is a negative number' do
            scenario 'does not create a reservable' do
              navigate_to_add_a_room
              complete_room_form(maximum_players: '-1')

              expect(page).to have_content 'must be greater than 0'
            end
          end
        end

        context 'the weekday_price is invalid' do
          scenario 'does not create a reservable' do
            navigate_to_add_a_room
            complete_room_form(weekday_price: '-1')

            expect(page).to have_content 'must be greater than or equal to 0'
          end
        end

        context 'the weekend_price is invalid' do
          scenario 'does not create a reservable' do
            navigate_to_add_a_room
            complete_room_form(weekend_price: '-1')

            expect(page).to have_content 'must be greater than or equal to 0'
          end
        end

        context 'the per_person_weekday_price is invalid' do
          scenario 'does not create a reservable' do
            navigate_to_add_a_room
            complete_room_form(per_person_weekday_price: '-1')

            expect(page).to have_content 'must be greater than or equal to 0'
          end
        end

        context 'the per_person_weekend_price is invalid' do
          scenario 'does not create a reservable' do
            navigate_to_add_a_room
            complete_room_form(per_person_weekend_price: '-1')

            expect(page).to have_content 'must be greater than or equal to 0'
          end
        end
      end

      def navigate_to_add_a_room
        visit root_path
        click_link 'Manage Business'
        click_link 'Add a Room'
      end

      def complete_room_form(overrides={})
        fill_in :reservable_name, with: overrides[:name] || 'Room 1'
        fill_in :reservable_interval, with: overrides[:interval] || 60
        fill_in :reservable_start_time, with: overrides[:start_time] || '10:00'
        fill_in :reservable_end_time, with: overrides[:end_time] ||'11:00'
        fill_in :reservable_maximum_players, with: overrides[:maximum_players] || 30
        fill_in :reservable_weekday_price, with: overrides[:weekday_price] || 10
        fill_in :reservable_weekend_price, with: overrides[:weekend_price] || 20
        fill_in :reservable_per_person_weekday_price, with: overrides[:per_person_weekday_price] || 5
        fill_in :reservable_per_person_weekend_price, with: overrides[:per_person_weekend_price] || 10
        click_on 'Submit'
      end
    end

    context 'Bowling exists' do
      background do
        @bowling = create(:bowling, business: @business)
      end

      context 'valid params' do
        scenario 'creates a correct type of reservable successfully' do
          visit root_path
          click_link 'Manage Business'
          click_link 'Add a Lane'
          fill_in :reservable_name, with: 'Room 1'
          fill_in :reservable_interval, with: 60
          fill_in :reservable_maximum_players, with: 30
          fill_in :reservable_weekday_price, with: 10
          fill_in :reservable_weekend_price, with: 20
          fill_in :reservable_per_person_weekday_price, with: 10
          fill_in :reservable_per_person_weekend_price, with: 15
          click_on 'Submit'

          expect(page).to have_content 'Lane was successfully added'
        end
      end
    end
  end
end
