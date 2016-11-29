feature 'View analytics', :js do
  background do
    @user = create(:user)
    business = create(:business, user: @user)

    @bowling = create(:bowling, business: business)
    lane = create(:lane, activity: @bowling)
  end
  include_context 'logged in user'

  context 'no bookings exist' do
    scenario 'shows an error message' do
      visit root_path
      click_link 'Manage Business'
      within("#activity_#{@bowling.id}") do
        click_link 'View analytics'
      end
      expect(page).to have_content('No bookings found.')
    end
  end
end
