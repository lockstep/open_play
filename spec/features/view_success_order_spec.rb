feature 'View Success Order' do
  background do
    @business = create(:business)
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'order is reserved' do
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
      expect(page).to have_content '$ 1'
      expect(page).to have_content 'Lane 1'
      expect(page).to have_content '09:00 AM - 10:00 AM'
      expect(page).to have_content '10'
    end

    scenario 'user sees social media buttons' do
      visit success_order_path(@order)
      expect(page).to have_content 'Share'
      expect(page).to have_content 'Tweet'
    end
  end
end
