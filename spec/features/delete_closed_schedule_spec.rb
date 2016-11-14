feature 'Delete Closed Schedule' do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  context 'a closed schedule exist' do
    before do
      activity = create(:bowling, business: @business)
      @closed_schedule = create(:closed_schedule, activity: activity)
    end

    scenario 'destroys a closed schedule' do
      visit root_path
      click_link 'Manage Business'
      click_link 'Edit'
      click_link 'Closing Time'
      click_link 'destroy-schedule-1'
      expect(page).to have_content 'Closing time deleted'
      expect(page).to_not have_content @closed_schedule.label
    end
  end
end
