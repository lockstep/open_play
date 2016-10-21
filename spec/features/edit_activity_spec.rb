feature 'edit activity' do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  context 'an activity exist' do
    before do
      @activity = create(:bowling, business: @business)
      @reservable = create(:lane, activity: @activity)
    end

    context 'user can edit the activity' do
      scenario 'successfully edited activity ' do
        visit root_path
        click_link 'Manage Business'
        expect(page).to have_content @activity.name
        click_link 'Edit'
        edit_activity_form(name: 'Super Bowling')
        expect(page).to have_content 'Successfully updated activity'
        expect(page).to have_content 'Super Bowling'
      end

      scenario 'unsuccessfully edited activity' do
        visit root_path
        click_link 'Manage Business'
        expect(page).to have_content @activity.name
        click_link 'Edit'
        edit_activity_form(name: '')
        expect(page).to have_content "can't be blank"
      end
    end

    scenario 'user can delete reservables' do
      visit root_path
      click_link 'Manage Business'
      click_link 'Edit'
      expect(page).to have_content @reservable.name
      click_link 'Delete'
      expect(page).to have_content 'Successfully deleted reservable'
      expect(page).to_not have_content @reservable.name
    end

    context 'user can edit reservables' do
      scenario 'successfully edited reservable' do
        visit root_path
        click_link 'Manage Business'
        click_link 'Edit'
        expect(page).to have_content @reservable.name
        click_link 'Edit'
        expect(page).to have_content 'Edit a Lane'
        fill_in :lane_name, with: 'Amazing Lane 1'
        click_on 'Submit'
        expect(page).to have_content 'Successfully updated reservable'
        expect(page).to have_content 'Amazing Lane 1'
      end
      scenario 'unsuccessfully edited reservable' do
        visit root_path
        click_link 'Manage Business'
        click_link 'Edit'
        expect(page).to have_content @reservable.name
        click_link 'Edit'
        expect(page).to have_content 'Edit a Lane'
        fill_in :lane_interval, with: ''
        fill_in :lane_name, with: ''
        click_on 'Submit'
        expect(page).to have_content "can't be blank"
        expect(page).to have_content "is not a number"
      end
    end
  end

  def edit_activity_form(overrides={})
    fill_in 'activity_name', with: overrides[:name] || 'Country Club Lanes'
    fill_in 'activity_start_time', with: overrides[:start_time] || '08:00'
    fill_in 'activity_end_time', with: overrides[:end_time] || '16:00'
    click_button 'Submit'
  end
end
