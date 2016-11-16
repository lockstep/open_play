feature 'Cancel Reservation', :js do
  background do
    @user = create(:user)
    business = create(:business, user: @user)
    @bowling = create(:bowling, business: business)
    @lane = create(:lane, name: 'lane', activity: @bowling)
  end
  include_context 'logged in user'

  context 'reservation exists' do
    background do
      order = create(:order, activity: @bowling)
      @booking = create(:booking, order: order, reservable: @lane,
        booking_date: '2016-10-13')
    end
    context 'business owner views reservations' do
      scenario 'displays the normal reservation correctly' do
        visit root_path
        click_link 'Manage Business'
        click_link 'View reservations'
        select_a_booking_date('2016-10-13')
        expect(page).to have_link 'Cancel'
        expect(page).to_not have_css("#booking_#{@booking.id}.table-danger")
      end
      context 'business owner cancels the reservation' do
        scenario 'displays the canceled reservation correctly' do
          visit root_path
          click_link 'Manage Business'
          click_link 'View reservations'
          select_a_booking_date('2016-10-13')
          click_link 'Cancel'
          expect(page).to have_content 'Successfully canceled'
          expect(page).to_not have_link 'Cancel'
          expect(page).to_not have_link 'Check in'
          expect(page).to have_css("#booking_#{@booking.id}.table-danger")
        end
      end
    end
  end
end
