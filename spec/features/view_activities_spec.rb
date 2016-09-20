feature 'View Business' do
  background do
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'a business exists' do
    before do
      @business = create(:business, user: @user)
    end

    context 'there are no activities' do
      scenario 'user sees there are no activities' do
        visit root_path
        click_link 'Manage Business'
        expect(page).to have_content "You haven't created any activities"
        expect(page).to have_link 'Create Activity',
          href: new_business_activity_path(@business)
      end
    end

    context 'an activity exists' do
      background do
        @activity = create(:activity, business: @business)
      end
      scenario 'user can see the activity' do
        visit root_path
        click_link 'Manage Business'
        expect(page).to have_content @activity.name
      end
    end
  end

  context 'a business does not exists' do
    scenario 'user sees there is no link to view activities' do
      visit root_path
      expect(page).not_to have_link 'Manage Business'
    end
  end
end
