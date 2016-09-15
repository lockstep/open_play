feature 'View activities' do
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
        click_link 'Businesses'
        click_link @business.name
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
        click_link 'Businesses'
        click_link @business.name
        expect(page).to have_content @activity.name
      end
    end
  end
end
