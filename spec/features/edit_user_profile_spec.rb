feature 'Edit User Profile' do
  background do
    @user = create(:user, email: 'superman@gmail.com')
  end
  include_context 'logged in user'

  context 'all params are submitted' do
    scenario 'successfully edited user profile' do
      navigate_to_edit_user_form
      complete_user_form

      expect(page).to have_content 'Successfully updated user profile'
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
      click_button 'Update'
    end
  end
end
