feature 'Confirm booking price is not changed', :js do
  background do
    @user = create(:user)
    business = create(:business, user: @user)
    @bowling = create(:bowling, business: business)
    @lane = create(:lane, name: 'lane_one', activity: @bowling,
      weekday_price: 5, per_person_weekday_price: 10)
  end
  include_context 'logged in user'

  context 'bookings exist' do
    background do
      @order = create(:order, user: @user, activity: @bowling)
      @booking = create(:booking, order: @order, reservable: @lane,
        start_time: '14:00:00', end_time: '15:00:00', booking_date: '2016-10-13',
        number_of_players: 2)
      @order.set_bookings_total_price
      @order.save
    end
    context 'business owner changes his booking price' do
      before { @lane.update(weekday_price: 30) }
      scenario 'shows old booking price' do
        travel_to Time.new(2016, 10, 13) do
          visit root_path
          click_link 'Manage Business'
          click_link 'View reservations'
          expect(page).to have_content '$ 25'
        end
      end
    end
  end
end
