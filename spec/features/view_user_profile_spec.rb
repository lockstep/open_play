feature 'View User Profile' do
  background do
    @user = create(:user, email: 'superman@gmail.com')
  end
  include_context 'logged in user'

  scenario 'displays user profile' do
    visit root_path
    within("nav") do
      click_button @user.email
    end
    click_link 'Your Profile'

    within '#user-information' do
      expect(page).to have_content 'superman@gmail.com'
      expect(page).to have_link 'Edit Profile'
    end
  end
end
