feature 'Create Business' do
  background do
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'all params are submitted' do
    scenario 'creates a bussiness' do
      visit root_path
      click_link 'Become a business owner'
      complete_business_form
      expect(page).to have_content 'Successfully created business'
      expect(page.current_path).to eq(activities_path)
    end
  end

  context 'business name is omitted' do
    scenario 'users sees that the business name is required' do
      visit root_path
      click_link 'Become a business owner'
      complete_business_form(name: '')
      expect(page).to have_content "can't be blank"
    end
  end

  def complete_business_form(overrides={})
    within '#new_business' do
      fill_in 'business_name', with: overrides[:name] || 'Dream World'
      fill_in 'business_description', with: overrides[:description] || 'Dream World is the amusement park for kids!'
      click_button 'Submit'
    end
  end
end
