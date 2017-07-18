feature 'Create Business' do
  background do
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'a business does not exist' do

    context 'all params are submitted' do
      scenario 'user can create the bussiness' do
        visit new_business_path
        business_name = 'Lazer center'
        complete_business_form(name: business_name)
        expect(page).to have_content 'Successfully created business'
        expect(page).to have_content "#{business_name}'s Activities"
        expect(Business.count).to eq 1
        business = Business.first
        expect(business.phone_number).to eq '1234567890'
        expect(business.description).to eq 'Dream World is the amusement park for kids!'
        expect(business.address).to eq 'Palo Alto, California, 94304, United States'
        expect(business.latitude).to eq 37.3947057
        expect(business.longitude).to eq (-122.15032510)
        expect(page.current_path).to eq(
          business_activities_path(@user.reload.business))
      end
    end

    context 'the business name is omitted' do
      scenario 'user sees the business name is required' do
        visit new_business_path
        complete_business_form(name: '')
        expect(page).to have_content "can't be blank"
      end
    end

    context 'the business description is omitted' do
      scenario 'user still can create the bussiness' do
        visit new_business_path
        business_name = 'Lazer center'
        complete_business_form(name: business_name, description: '')
        expect(page).to have_content 'Successfully created business'
        expect(page).to have_content "#{business_name}'s Activities"
        expect(page.current_path).to eq(
          business_activities_path(@user.reload.business))
      end
    end
  end

  def complete_business_form(overrides={})
    within '#new_business' do
      fill_in 'business_name', with: overrides[:name] || 'Dream World'
      fill_in 'business_phone_number', with: overrides[:phone_number] || 1234567890
      fill_in 'business_description', with: overrides[:description] ||
        'Dream World is the amusement park for kids!'
      complete_business_location
      click_button 'Submit'
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
