feature 'View Business' do
  background { @user = create(:user) }

  context 'user is logged in' do
    include_context 'logged in user'

    context 'normal user' do
      background do
        @business = create(:business)
        activity = create(:laser_tag, business: @business)
        create(:reservable, activity: activity)
        visit root_path
        search_activities(activity_type: 'Laser tag')
        click_on @business.name
      end

      scenario 'does not see link to edit business' do
        expect(page).to_not have_link('Edit Your Business')
      end

      scenario 'sees business info' do
        expect(page).to have_content 'Disneyland'
        expect(page).to have_content 'amazing amusement park'
        expect(page).to have_content '1234567890'
        expect(page).to have_content '123 building'
      end

      scenario 'sees activity info' do
        expect(page).to have_content 'Country Club'
      end

    end

    context 'business owner' do
      background do
        @business = create(:business, user: @user)
        activity = create(:laser_tag, business: @business)
        create(:reservable, activity: activity)
        visit root_path
        search_activities(activity_type: 'Laser tag')
        click_on @business.name
      end

      scenario 'sees link to edit business' do
        expect(page).to have_link('Edit Your Business')
      end

      scenario 'sees business info' do
        expect(page).to have_content 'Disneyland'
        expect(page).to have_content 'amazing amusement park'
        expect(page).to have_content '1234567890'
        expect(page).to have_content '123 building'
      end

      scenario 'sees activity info' do
        expect(page).to have_content 'Country Club'
      end

    end
  end

  context 'user is not logged in' do
    background do
      @business = create(:business)
      activity = create(:laser_tag, business: @business)
      create(:reservable, activity: activity)
      visit root_path
      search_activities(activity_type: 'Laser tag')
      click_on @business.name
    end

    scenario 'does not see link to edit business' do
      expect(page).to_not have_link('Edit Your Business')
    end

    scenario 'sees business info' do
      expect(page).to have_content 'Disneyland'
      expect(page).to have_content 'amazing amusement park'
      expect(page).to have_content '1234567890'
      expect(page).to have_content '123 building'
    end

    scenario 'sees activity info' do
      expect(page).to have_content 'Country Club'
    end

  end
end
