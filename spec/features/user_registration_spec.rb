feature 'User registers', :js do
  context 'all fields complete' do
    scenario 'user is authenticated' do
      visit root_path
      click_link 'Sign Up'
      fill_out_registration
      click_button 'Sign up'
      expect(page).to have_content 'successful'
    end
  end
  context 'first name omitted' do
    scenario 'user is informed it is required' do
      visit root_path
      click_link 'Sign Up'
      fill_out_registration(first_name: '')
      click_button 'Sign up'
      expect(page).to have_content "can't be blank"
    end
  end

  def fill_out_registration(overrides={})
    fill_in 'user[first_name]', with: overrides[:first_name] || 'peter'
    fill_in 'user[last_name]', with: overrides[:last_name] || 'pan'
    fill_in 'user[email]', with: overrides[:email] || 'peter@gmail.com'
    fill_in 'user[password]', with: overrides[:password] || '123456'
    fill_in 'user[password_confirmation]', with: overrides[:password_confirmation] || '123456'
  end
end
