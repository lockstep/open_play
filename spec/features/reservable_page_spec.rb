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
        visit root_path
        click_link 'Manage Business'
        click_link 'Add a Room'
      end

      context 'valid params' do
        background do
          fill_in :room_name, with: 'Room 1'
          fill_in :room_interval, with: 60
          fill_in :room_maximum_players, with: 30
          click_on 'Submit'
        end
        scenario 'creates a correct type of reservable successfully' do
          expect(page).to have_content 'Room was successfully added'
        end
      end
      context 'invalid params' do
        background do
          fill_in :room_interval, with: '60 mins'
          fill_in :room_start_time, with: '10:00'
          fill_in :room_end_time, with: '09:00'
          fill_in :room_maximum_players, with: '-1'
          click_on 'Submit'
        end
        scenario 'does not create a reservable' do
          expect(page).to have_content 'not a number'
          expect(page).to have_content 'must be after the start time'
          expect(page).to have_content 'must be greater than 0'
        end
      end
    end

    context 'Bowling tag exists' do
      background do
        @bowling = create(:bowling, business: @business)
        visit root_path
        click_link 'Manage Business'
        click_link 'Add a Lane'
      end

      context 'valid params' do
        background do
          fill_in :lane_name, with: 'Room 1'
          fill_in :lane_interval, with: 60
          click_on 'Submit'
        end
        scenario 'creates a correct type of reservable successfully' do
          expect(page).to have_content 'Lane was successfully added'
        end
      end
      context 'invalid params' do
        background do
          fill_in :lane_interval, with: '60 mins'
          fill_in :lane_start_time, with: '10:00'
          fill_in :lane_end_time, with: '09:00'
          click_on 'Submit'
        end
        scenario 'does not create a reservable' do
          expect(page).to have_content 'not a number'
          expect(page).to have_content 'must be after the start time'
        end
      end
    end
  end
end
