feature 'View Success Order' do
  background do
    @business = create(:business)
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'bowling exists' do
    background do
      bowling = create(:bowling, business: @business)
      lane = create(:lane, activity: bowling)
      @order = create(:order, user: @user, activity: bowling)
      create(:booking, order: @order, reservable: lane)
    end

    scenario 'user sees completed order information' do
      visit success_order_path(@order)
      expect(page).to have_content 'Tom Cruise'
      expect(page).to have_content 'Saturday, February 3'
      expect(page).to have_content 'Country Club Lanes'
      expect(page).to have_content '$1'
      expect(page).to have_content 'Lane 1'
      expect(page).to have_content '09:00 AM - 10:00 AM'
      expect(page).to have_content '10'
    end

    scenario 'user sees social media buttons' do
      visit success_order_path(@order)
      expect(page).to have_content 'Share'
      expect(page).to have_content 'Tweet'
    end

    scenario 'renders correct metatags' do
      title = 'I just booked a round of bowling on OpenPlay at Country Club Lanes'
      description = 'So much fun with your family'
      url = "http://www.example.com/businesses/#{@business.id}"

      visit success_order_path(@order)
      expect(page).to have_meta_property('og:title', title)
      expect(page).to have_meta_property('og:description', description)
      expect(page).to have_meta_property('og:url', url)
      expect(page).to have_meta_name('twitter:title', title)
      expect(page).to have_meta_name('twitter:description', description)
    end
  end

  context 'laser tag exists' do
    background do
      laser_tag = create(:laser_tag, business: @business)
      room = create(:room, activity: laser_tag)
      @order = create(:order, user: @user, activity: laser_tag)
      create(:booking, order: @order, reservable: room)
    end

    scenario 'renders correct metatags' do
      title = 'I just booked a room of laser tag on OpenPlay at Country Club Laser Tag'
      description = 'So much fun with your family'
      url = "http://www.example.com/businesses/#{@business.id}"

      visit success_order_path(@order)
      expect(page).to have_meta_property('og:title', title)
      expect(page).to have_meta_property('og:description', description)
      expect(page).to have_meta_property('og:url', url)
      expect(page).to have_meta_name('twitter:title', title)
      expect(page).to have_meta_name('twitter:description', description)
    end
  end
end
