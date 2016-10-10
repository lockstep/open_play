feature 'Search Activities', js: true do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  describe 'Bowlings exist' do
    background do
      @bowling = create(:bowling, business: @business)
      @bowling_2 = create(:bowling, name: 'Classic Bowling', business: @business)
      visit root_path
    end
    context 'has multiple lanes' do
      background do
        @lane = create(:lane, activity: @bowling)
        @lane_2 = create(
          :lane,
          name: 'Lane 2',
          activity: @bowling,
          start_time: '10:00',
          end_time: '20:00'
        )
      end
      context 'results found' do
        background do
          page.execute_script("$('#timepicker').val('11:00')")
          page.select 'Bowling', :from => 'activity_type'
          click_on 'Search'
        end
        scenario 'shows list of results' do
          expect(page).to have_content @bowling.name
          expect(page).to have_content @bowling_2.name
        end
        scenario 'the desired booking time is centered along with alternative times' do
          expect(page).to have_content @lane.name
          expect(page).to have_content '09:00 10:00 11:00 12:00 13:00'
          expect(page).to have_content @lane_2.name
          expect(page).to have_content '--:-- 10:00 11:00 12:00 13:00'
        end
      end
    end

    context 'no results found' do
      background do
        page.select 'Laser tag', :from => 'activity_type'
        click_on 'Search'
      end
      scenario 'shows the appropiate message' do
        expect(page).to have_content 'No results found'
      end
    end
  end

end
