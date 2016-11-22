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
    expect(page).to have_content @user.first_name
    expect(page).to have_content @user.last_name
    expect(page).to have_content @user.email
    expect(page).to have_content @user.phone_number
    expect(page).to have_link 'Edit Profile'
  end
end
