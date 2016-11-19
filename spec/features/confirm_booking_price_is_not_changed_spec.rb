feature 'Confirm booking price is not changed', :js do
  background do
    @bowling = create(:bowling)
    @lane = create(:lane, name: 'lane_one', activity: @bowling,
      weekday_price: 5, per_person_weekday_price: 10)
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'bookings exist' do
    background do
      @order = create(:order, user: @user, activity: @bowling)
      @booking = create(:booking, order: @order, reservable: @lane,
        start_time: '14:00:00', end_time: '15:00:00', booking_date: '2016-10-13',
        number_of_players: 2)
      @order.set_price_of_bookings
      @order.save
    end
    context 'business owner changes his booking price' do
      before { @lane.update(weekday_price: 30) }
      scenario 'shows old booking price' do
        travel_to Time.new(2016, 10, 13) do
          visit root_path
          within("nav") do
            click_button @user.email
          end
          click_link 'Your Bookings'
          expect(page).to have_content '$ 25'
        end
      end
    end
  end
end
