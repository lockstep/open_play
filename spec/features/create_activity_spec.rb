feature 'Create Activity' do
  background do
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'a business exists' do
    before do
      @business = create(:business, user: @user)
    end

    context 'an activity does not exist' do
      before do
        visit root_path
        click_link 'Manage Business'
        click_link 'Create Activity'
      end

      context 'all params are submitted' do
        scenario 'user can create the activity' do
          activity_name = 'Table Tennis'
          complete_activity_form(name: activity_name)
          expect(page).to have_content 'Successfully created activity'
          expect(page).to have_content activity_name
          expect(page.current_path).to eq(business_activities_path(@business))
        end
      end

      context 'the activity name is omitted' do
        scenario 'user sees the activity name is required' do
          complete_activity_form(name: '')
          expect(page).to have_content "can't be blank"
        end
      end

      context 'wrong end_time scheduling' do
        context 'end_time is scheduled before start_time' do
          scenario 'user sees end_time need to schedule after start_time' do
            complete_activity_form(
              start_time_hours: '12', start_time_minutes: '30',
              end_time_hours: '08', end_time_minutes: '00'
            )
            expect(page).to have_content 'must be after the start time'
          end
        end
        context 'end_time is equal start_time' do
          scenario 'user sees end_time need to schedule after start_time' do
            complete_activity_form(
              start_time_hours: '08', start_time_minutes: '00',
              end_time_hours: '08', end_time_minutes: '00'
            )
            expect(page).to have_content 'must be after the start time'
          end
        end
      end
    end

    context 'an activity exist' do
      before do
        create(:bowling, business: @business)
        visit root_path
        click_link 'Manage Business'
        click_link 'Add activity'
      end

      context 'all params are submitted' do
        scenario 'user can add more activity' do
          activity_name = 'Bowling Club'
          complete_activity_form(name: activity_name)
          expect(page).to have_content 'Successfully created activity'
          expect(page).to have_content activity_name
          expect(page.current_path).to eq(business_activities_path(@business))
        end
      end
    end
  end

  def complete_activity_form(overrides={})
    within '#new_activity' do
      select( overrides[:type] || 'Bowling', :from => 'activity_type')
      fill_in 'activity_name', with: overrides[:name] || 'Country Club Lanes'
      select( overrides[:start_time_hours] || '08', :from => 'activity_start_time_4i')
      select( overrides[:start_time_minutes] || '00', :from => 'activity_start_time_5i')
      select( overrides[:end_time_hours] || '16', :from => 'activity_end_time_4i')
      select( overrides[:end_time_minutes] || '00', :from => 'activity_end_time_5i')
      click_button 'Submit'
    end
  end
end
