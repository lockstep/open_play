feature 'View Activities' do
  background do
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'a business exists' do
    background do
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
      context 'Bowling has many lanes' do
        background do
          @activity = create(:bowling, business: @business)
          @activity.lanes.create([
              reservable_params,
              reservable_params(name: 'Lane B')
            ])
        end

        scenario 'user can see the activity' do
          visit root_path
          click_link 'Manage Business'

          expect(page).to have_content @activity.name
        end

        scenario 'can add a lane' do
          visit root_path
          click_link 'Manage Business'

          expect(page).to have_link 'Add a Lane'
        end

        scenario 'shows all lanes of the activity' do
          visit root_path
          click_link 'Manage Business'
          expect(page).to have_content @activity.reservables.first.name
          expect(page).to have_content @activity.reservables.second.name
        end

        scenario 'shows link to view reservations' do
          visit root_path
          click_link 'Manage Business'
          expect(page).to have_link 'View reservations'
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
      name: overrides[:name] || 'Item A',
      interval: 30,
      start_time: '08:00',
      end_time: '20:00',
      maximum_players: 30,
      weekday_price: 15,
      weekend_price: 20
    }
  end
end
