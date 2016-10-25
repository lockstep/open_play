feature 'Edit Business' do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  context 'a business exist' do

    scenario 'successful updated business' do
      visit root_path
      click_link 'Your Business'
      expect(page).to have_content @business.name
      click_link 'Edit Your Business'
      fill_in 'business_name', with: '123 Company'
      click_button 'Save'
      expect(page).to have_content "Successfully updated business"
      expect(page).to have_content "123 Company"
    end

    scenario 'cancel updated business' do
      visit root_path
      click_link 'Your Business'
      business_name = @business.name
      expect(page).to have_content business_name
      click_link 'Edit Your Business'
      fill_in 'business_name', with: '123 Company'
      click_link 'Cancel'
      expect(page).to have_content business_name
      expect(page.current_path).to eq(businesses_show_path())
    end

    scenario 'unsuccessful updated business' do
      visit root_path
      click_link 'Your Business'
      click_link 'Edit Your Business'
      fill_in 'business_name', with: ''
      fill_in 'business_phone_number', with: 12345678910111213
      click_button 'Save'
      expect(page).to have_content "can't be blank"
      expect(page).to have_content "is too long"
    end
  end
end
