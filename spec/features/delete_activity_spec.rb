feature 'delete activity' do
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

    scenario 'user can delete the activity' do
      expect(page).to have_content @activity.name
      click_link 'Delete'
      expect(page).to have_content 'Successfully deleted activity'
      expect(page).to_not have_content @activity.name
    end
  end
end
