feature 'edit activity' do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  context 'an activity exist' do
    before do
      @activity = create(:bowling, business: @business)
      visit root_path
      click_link 'Manage Business'
    end

    scenario 'user can edit the activity' do
      expect(page).to have_content @activity.name
      click_link 'Edit'
      edit_activity_form(name: 'Super Bowling')
      expect(page).to have_content 'Successfully updated activity'
      expect(page).to have_content 'Super Bowling'
    end
  end

  def edit_activity_form(overrides={})
    select( overrides[:type] || 'Bowling', :from => 'activity_type')
    fill_in 'activity_name', with: overrides[:name] || 'Country Club Lanes'
    fill_in 'activity_start_time', with: overrides[:start_time] || '08:00'
    fill_in 'activity_end_time', with: overrides[:end_time] || '16:00'
    click_button 'Submit'
  end
end
