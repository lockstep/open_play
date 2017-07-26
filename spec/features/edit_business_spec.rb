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
      click_link 'Edit Your Business'
      expect(page).to have_field('business[name]', with: @business.name)
      expect(page).to have_field('business[phone_number]', with: @business.phone_number)
      expect(page).to have_field('geocoding_address', with: @business.geocoding_address)
      expect(page).to have_field('business[description]', with: @business.description)
      complete_business_form
      expect(page).to have_content 'Successfully updated business'
      expect(page).to have_content '0123456789'
      expect(page).to have_content 'Palo Alto, California, 94304, United States'
      expect(@business.reload.description).to eq 'Cool!'
      expect(@business.latitude).to eq 37.3947057
      expect(@business.longitude).to eq (-122.15032510)
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
      expect(page.current_path).to eq business_path(@business)
    end

    scenario 'unsuccessful updated business' do
      visit root_path
      click_link 'Your Business'
      click_link 'Edit Your Business'
      complete_business_form(name: '')
      click_button 'Save'
      expect(page).to have_content "can't be blank"
    end
  end

  def complete_business_form(overrides = {})
    within 'form' do
      fill_in 'business[name]', with: overrides[:name] || '123 Company'
      fill_in 'business[phone_number]', with: overrides[:phone_number] || '0123456789'
      fill_in 'business[description]', with: overrides[:description] || 'Cool!'
      complete_business_location
      click_button 'Save'
    end
  end

  def complete_business_location
    find(:xpath, "//input[@id='business_latitude']", visible: false)
      .set '37.3947057'
    find(:xpath, "//input[@id='business_longitude']", visible: false)
      .set '-122.15032510'
    find(:xpath, "//input[@id='business_city']", visible: false)
      .set 'Palo Alto'
    find(:xpath, "//input[@id='business_state']", visible: false)
      .set 'California'
    find(:xpath, "//input[@id='business_zip']", visible: false)
      .set '94304'
    find(:xpath, "//input[@id='business_country']", visible: false)
      .set 'United States'
  end
end
