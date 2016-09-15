feature 'Create Business' do
  background do
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'a business does not exist' do
    before do
      visit root_path
      click_link 'Businesses'
      click_link 'Create business'
    end

    context 'all params are submitted' do
      scenario 'user can create the bussiness' do
        business_name = 'Lazer center'
        complete_business_form(name: business_name)
        expect(page).to have_content 'Successfully created business'
        expect(page).to have_content business_name
        expect(page.current_path).to eq(businesses_path)
      end
    end

    context 'the business name is omitted' do
      scenario 'user sees the business name is required' do
        complete_business_form(name: '')
        expect(page).to have_content "can't be blank"
      end
    end

    context 'the business description is omitted' do
      scenario 'user still can create the bussiness' do
        business_name = 'Lazer center'
        complete_business_form(name: business_name, description: '')
        expect(page).to have_content 'Successfully created business'
        expect(page).to have_content business_name
        expect(page.current_path).to eq(businesses_path)
      end
    end
  end

  context 'a business exist' do
    before do
      create(:business, user: @user)
      visit root_path
      click_link 'Businesses'
      click_link 'Add business'
    end

    context 'all params are submitted' do
      scenario 'user can add more bussiness' do
        business_name = 'Lazer center'
        complete_business_form(name: business_name)
        expect(page).to have_content 'Successfully created business'
        expect(page).to have_content business_name
        expect(page.current_path).to eq(businesses_path)
      end
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
