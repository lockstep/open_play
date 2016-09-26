feature 'View Activities' do
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
        expect(page).to_not have_link 'Add a Reservable'
      end
    end

    context 'an activity exists' do
      background do
        @activity = create(:activity, business: @business)
        visit root_path
        click_link 'Manage Business'
      end
      scenario 'user can see the activity' do
        expect(page).to have_content @activity.name
      end
      scenario 'can add a reservable' do
        expect(page).to have_link 'Add a Reservable'
      end

      xcontext 'has reservables' do
        before do
          @activity.reservables.create([
            reservable_params,
            reservable_params(name: 'Field B')
          ])
        end
        scenario 'shows all reservables of the activity' do
          reservables = @activity.reservables
          expect(page).to have_content reservables.first.name
          expect(page).to have_content reservables.second.name
        end
      end
    end
  end

  context 'a business does not exists' do
    scenario 'user sees there is no link to view activities' do
      visit root_path
      expect(page).not_to have_link 'Manage Business'
    end
  end

  def reservable_params(overrides={})
    {
      name: overrides[:name] || 'Field A',
      interval: 30,
      start_time: '08:00',
      end_time: '20:00'
    }
  end
end
