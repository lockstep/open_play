feature 'Create Business' do
  background do
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'a business does not exist' do

    context 'all params are submitted' do
      scenario 'user can create the bussiness' do
        visit root_path
        click_link 'Join us'
        business_name = 'Lazer center'
        complete_business_form(name: business_name)
        expect(page).to have_content 'Successfully created business'
        expect(page).to have_content "#{business_name}'s Activities"
        expect(page.current_path).to eq(
          business_activities_path(@user.reload.business))
      end
    end

    context 'the business name is omitted' do
      scenario 'user sees the business name is required' do
        visit root_path
        click_link 'Join us'
        complete_business_form(name: '')
        expect(page).to have_content "can't be blank"
      end
    end

    context 'the business description is omitted' do
      scenario 'user still can create the bussiness' do
        visit root_path
        click_link 'Join us'
        business_name = 'Lazer center'
        complete_business_form(name: business_name, description: '')
        expect(page).to have_content 'Successfully created business'
        expect(page).to have_content "#{business_name}'s Activities"
        expect(page.current_path).to eq(
          business_activities_path(@user.reload.business))
      end
    end
  end

  context 'a business exist' do
    before { create(:business, user: @user) }
    scenario 'user cannot add more businesses' do
      visit root_path
      expect(page).not_to have_link 'Join us'
    end
  end

  def complete_business_form(overrides={})
    within '#new_business' do
      fill_in 'business_name', with: overrides[:name] || 'Dream World'
      fill_in 'business_phone_number', with: overrides[:phone_number] || 1234567890
      fill_in 'business_address', with: overrides[:address] || '123 Bangkok'
      fill_in 'business_description', with: overrides[:description] || 'Dream World is the amusement park for kids!'
      click_button 'Submit'
    end
  end
end
