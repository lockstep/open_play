feature 'View Landing Page' do
  background do
    @user = create(:user)
    @user.update(
      session_address: 'Casablanca, Morocco',
      session_latitude: 33.5758954,
      session_longitude: (-7.70682099),
      last_searched_at: DateTime.new(2017, 5, 10, 10, 0, 0)
    )
  end
  include_context 'logged in user'

  context 'user with no location' do
    scenario 'resets session location' do
      time_now = DateTime.new(2017, 5, 10, 18, 0, 0)
      allow(Time).to receive(:now).and_return(time_now)
      expect_any_instance_of(User).to receive(:should_reset_session_location?).
        and_return(true)

      visit root_path
      expect(page).to have_content 'Making Family Fun Easy!'
      expect(find('.place-address', visible: false).value).to eq nil
      expect(find('.place-latitude', visible: false).value).to eq nil
      expect(find('.place-longitude', visible: false).value).to eq nil
      expect(@user.session_address).to eq nil
      expect(@user.session_latitude).to eq nil
      expect(@user.session_longitude).to eq nil
      expect(@user.last_searched_at).to eq time_now
    end

    scenario 'not resets session location' do
      expect_any_instance_of(User).to receive(:should_reset_session_location?).
        and_return(false)

      visit root_path
      expect(page).to have_content 'Making Family Fun Easy!'
      expect(find('.place-address', visible: false).value).to eq 'Casablanca, Morocco'
      expect(find('.place-latitude', visible: false).value).to eq '33.5758954'
      expect(find('.place-longitude', visible: false).value).to eq '-7.70682099'

      expect(@user.session_address).to eq 'Casablanca, Morocco'
      expect(@user.session_latitude).to eq 33.5758954
      expect(@user.session_longitude).to eq (-7.70682099)
      expect(@user.last_searched_at).to eq  DateTime.new(2017, 5, 10, 10, 0, 0)
    end
  end

  context 'user with location' do
    background do
      @user.update(
        address: '1455 Market St #400, San Francisco, CA 94103, USA',
        latitude: 37.7752315, longitude: (-122.4175278)
      )
    end

    scenario 'resets session location' do
      time_now = DateTime.new(2017, 5, 10, 18, 0, 0)
      allow(Time).to receive(:now).and_return(time_now)
      expect_any_instance_of(User).to receive(:should_reset_session_location?).
        and_return(true)

      visit root_path
      expect(page).to have_content 'Making Family Fun Easy!'
      expect(find('.place-address', visible: false).value)
        .to eq'1455 Market St #400, San Francisco, CA 94103, USA'
      expect(find('.place-latitude', visible: false).value).to eq '37.7752315'
      expect(find('.place-longitude', visible: false).value).to eq '-122.4175278'

      expect(@user.session_address).to eq nil
      expect(@user.session_latitude).to eq nil
      expect(@user.session_longitude).to eq nil
      expect(@user.last_searched_at).to eq time_now
    end

    scenario 'not resets session location' do
      expect_any_instance_of(User).to receive(:should_reset_session_location?).
        and_return(false)

      visit root_path
      expect(page).to have_content 'Making Family Fun Easy!'
      expect(find('.place-address', visible: false).value).to eq 'Casablanca, Morocco'
      expect(find('.place-latitude', visible: false).value).to eq '33.5758954'
      expect(find('.place-longitude', visible: false).value).to eq '-7.70682099'

      expect(@user.session_address).to eq 'Casablanca, Morocco'
      expect(@user.session_latitude).to eq 33.5758954
      expect(@user.session_longitude).to eq (-7.70682099)
      expect(@user.last_searched_at).to eq  DateTime.new(2017, 5, 10, 10, 0, 0)
    end
  end
end
