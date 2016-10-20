feature 'delete activity' do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  context 'an activity exist' do
    before { @activity = create(:bowling, business: @business) }

    scenario 'user can delete the activity' do
      visit root_path
      click_link 'Manage Business'
      expect(page).to have_content @activity.name
      click_link 'Delete'
      expect(page).to have_content 'Successfully deleted activity'
      expect(page).to_not have_content @activity.name
    end
  end
end
