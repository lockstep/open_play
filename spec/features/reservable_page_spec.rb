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
        expect(find_field('lane_start_time').value).to match '09:00'
        expect(find_field('lane_end_time').value).to match '17:00'
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
          visit root_path
          click_link 'Manage Business'
          click_link 'Add a Room'
          fill_in :room_name, with: 'Room 1'
          fill_in :room_interval, with: 60
          fill_in :room_maximum_players, with: 30
          fill_in :room_weekday_price, with: 10
          fill_in :room_weekend_price, with: 20
          click_on 'Submit'

          expect(page).to have_content 'Room was successfully added'
        end
      end
      context 'invalid params' do
        context 'root_interval is invalid' do
          scenario 'does not create a reservable' do
            visit root_path
            click_link 'Manage Business'
            click_link 'Add a Room'
            fill_in :room_name, with: 'Room 1'
            fill_in :room_interval, with: '60 min'
            fill_in :room_maximum_players, with: 30
            fill_in :room_weekday_price, with: 10
            fill_in :room_weekend_price, with: 20
            click_on 'Submit'

            expect(page).to have_content 'is not a number'
          end
        end

        context 'room_end_time is invalid' do
          scenario 'does not create a reservable' do
            visit root_path
            click_link 'Manage Business'
            click_link 'Add a Room'
            fill_in :room_name, with: 'Room 1'
            fill_in :room_interval, with: 60
            fill_in :room_start_time, with: '10:00'
            fill_in :room_end_time, with: '09:00'
            fill_in :room_maximum_players, with: 30
            fill_in :room_weekday_price, with: 10
            fill_in :room_weekend_price, with: 20
            click_on 'Submit'

            expect(page).to have_content 'must be after the start time'
          end
        end

        context 'room_maximum_players is invalid' do
          context 'room_maximum_players is a string' do
            scenario 'does not create a reservable' do
              visit root_path
              click_link 'Manage Business'
              click_link 'Add a Room'
              fill_in :room_name, with: 'Room 1'
              fill_in :room_interval, with: 60
              fill_in :room_weekday_price, with: 10
              fill_in :room_weekend_price, with: 20
              fill_in :room_maximum_players, with: 'hello'
              click_on 'Submit'

              expect(page).to have_content 'is not a number'
            end
          end

          context 'room_maximum_players is a negative number' do
            scenario 'does not create a reservable' do
              visit root_path
              click_link 'Manage Business'
              click_link 'Add a Room'
              fill_in :room_name, with: 'Room 1'
              fill_in :room_interval, with: 60
              fill_in :room_weekday_price, with: 10
              fill_in :room_weekend_price, with: 20
              fill_in :room_maximum_players, with: -1
              click_on 'Submit'

              expect(page).to have_content 'must be greater than 0'
            end
          end
        end

        context 'room_weekday_price is invalid' do
          scenario 'does not create a reservable' do
            visit root_path
            click_link 'Manage Business'
            click_link 'Add a Room'
            fill_in :room_name, with: 'Room 1'
            fill_in :room_interval, with: 60
            fill_in :room_maximum_players, with: 30
            fill_in :room_weekend_price, with: 20
            fill_in :room_weekday_price, with: -1
            click_on 'Submit'

            expect(page).to have_content 'must be greater than 0'
          end
        end

        context 'room_weekend_price is invalid' do
          scenario 'does not create a reservable' do
            visit root_path
            click_link 'Manage Business'
            click_link 'Add a Room'
            fill_in :room_name, with: 'Room 1'
            fill_in :room_interval, with: 60
            fill_in :room_maximum_players, with: 30
            fill_in :room_weekday_price, with: 10
            fill_in :room_weekend_price, with: -1
            click_on 'Submit'

            expect(page).to have_content 'must be greater than 0'
          end
        end
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
          fill_in :lane_name, with: 'Room 1'
          fill_in :lane_interval, with: 60
          fill_in :lane_maximum_players, with: 30
          fill_in :lane_weekday_price, with: 10
          fill_in :lane_weekend_price, with: 20
          click_on 'Submit'

          expect(page).to have_content 'Lane was successfully added'
        end
      end
    end
  end
end
