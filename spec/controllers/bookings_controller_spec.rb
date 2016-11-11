describe BookingsController do
  describe 'PATCH update' do
    context 'a booking exists' do
      before do
        @business = create(:business)
        laser_tag = create(:laser_tag, business: @business)
        room = create(:room, activity: laser_tag)
        order = create(:order, activity: laser_tag)
        @booking = create(:booking, order: order, reservable: room)
      end

      context 'user is logged in' do
        login_user
        context 'user is a business owner' do
          before { @business.update(user: @user) }
          it 'check a reservation in' do
            patch :check_in, params: { id: @booking.id }
            expect(Booking.first.checked_in).to be true
          end
        end
        context 'user is not a business owner' do
          before do
            patch :check_in, params: { id: @booking.id }
          end
          it_behaves_like 'an unauthorized request'
        end
      end
      context 'user is not logged in' do
        before do
          patch :check_in, params: { id: @booking.id }
        end
        it_behaves_like 'it requires authentication'
      end
    end
  end
end
