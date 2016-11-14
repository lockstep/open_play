feature 'Check Reservation In', :js do
  background do
    @user = create(:user)
    business = create(:business, user: @user)
    @bowling = create(:bowling, business: business)
    @lane = create(:lane, name: 'lane', activity: @bowling)
  end
  include_context 'logged in user'

  context 'bookings exist' do
    background do
      order = create(:order, user: @user, activity: @bowling)
      @booking = create(:booking, order: order, reservable: @lane,
        booking_date: '2016-10-13')
    end

    context 'booking_date and system date are not the same' do
      context 'before check reservation in' do
        scenario 'displays row in table correctly' do
          travel_to Time.new(2016, 10, 11) do
            visit root_path
            click_link 'Manage Business'
            click_link 'View reservations'
            select_a_booking_date('2016-10-13')
          end
          expect(page).to have_link 'Checked in'
          expect(page).to_not have_css("#booking_#{@booking.id}.table-success")
        end
      end
      context 'after check reservation in' do
        scenario 'booking is updated' do
          travel_to Time.new(2016, 10, 11) do
            visit root_path
            click_link 'Manage Business'
            click_link 'View reservations'
            select_a_booking_date('2016-10-13')
            click_link 'Checked in'
          end
          expect(page).to have_content 'Successfully checked in'
          expect(page).to_not have_link 'Checked in'
          expect(page).to have_css("#booking_#{@booking.id}.table-success")
        end
      end
    end
  end
end
