feature 'delete reservable' do
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

    scenario 'user can delete reservables' do
      visit root_path
      click_link 'Manage Business'
      click_link 'Edit'
      expect(page).to have_content @reservable.name
      click_link 'Delete'

      expect(page).to have_content 'Successfully deleted reservable'
      expect(page).to_not have_content @reservable.name
    end
  end
end
