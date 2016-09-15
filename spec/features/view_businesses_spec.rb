feature 'View Buinsesses' do
  background do
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'there are no businesses' do
    scenario 'user sees there are no businesses' do
      visit root_path
      click_link 'Businesses'
      expect(page).to have_content "You haven't created any businesses"
      expect(page).to have_link 'Create business', href: new_business_path
    end
  end

  context 'a business exist' do
    background do
      @business = create(:business, user: @user)
    end
    scenario 'user can see the business' do
      visit root_path
      click_link 'Businesses'
      expect(page).to have_link @business.name
    end
  end
end
