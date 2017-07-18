feature 'Edit User Profile' do
  background do
    @user = create(:user_with_location, email: 'superman@gmail.com')
  end
  include_context 'logged in user'

  context 'all params are submitted' do
    scenario 'successfully edited user profile' do
      navigate_to_edit_user_form
      expect(page).to have_content 'Edit Profile'
      expect(page).to have_content @user.email
      expect(page).to have_field('user[first_name]', with: @user.first_name)
      expect(page).to have_field('user[last_name]', with: @user.last_name)
      expect(page).to have_field('user[phone_number]', with: @user.phone_number)
      expect(page).to have_field('location', with: @user.address)
      complete_user_form

      expect(page).to have_content 'Successfully updated user profile'
      expect(page).to have_content 'eric'
      expect(page).to have_content 'schmidt'
      expect(page).to have_content '+1 650-253-0000'
      expect(page).to have_content 'Daly City, CA, USA'
      expect(@user.reload.latitude).to eq 37.6879241
      expect(@user.longitude).to eq (-122.47020789)
      expect(current_path).to eq user_path(@user)
    end
  end

  context 'some params are invalid' do
    context 'password_confirmation does not match password' do
      scenario 'unsuccessfully edited user profile' do
        navigate_to_edit_user_form
        complete_user_form(password_confirmation: 'abcdefg')

        expect(page).to have_content "doesn't match Password"
      end
    end
  end

  def navigate_to_edit_user_form
    visit root_path
    within("nav") do
      click_button @user.email
    end
    click_link 'Your Profile'
    click_link 'Edit Profile'
  end

  def complete_user_form(overrides={})
    within '#edit_user_form' do
      fill_in 'user[first_name]', with: overrides[:first_name] || 'eric'
      fill_in 'user[last_name]', with: overrides[:first_name] || 'schmidt'
      fill_in 'user[phone_number]', with: overrides[:phone_number] || '+1 650-253-0000'
      fill_in 'user[password]', with: overrides[:password] || '123456'
      fill_in 'user[password_confirmation]', with: overrides[:password_confirmation] || '123456'
      update_address
      click_button 'Update'
    end
  end

  def update_address
    find(:xpath, "//input[@id='user_address']", visible: false)
      .set 'Daly City, CA, USA'
    find(:xpath, "//input[@id='user_latitude']", visible: false)
      .set '37.6879241'
    find(:xpath, "//input[@id='user_longitude']", visible: false)
      .set '-122.47020789'
  end
end
