describe OrdersController do
  describe 'GET new' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'an activity exists' do
        before { @activity = create(:bowling, business: @business) }
        context 'user is logged in' do
          login_user
          before do
            @business.update(user: @user)
            get :new, params: order_params(activity_id: @activity.id)
          end
          it_behaves_like 'a successful request'
        end
        context 'user is not logged in' do
          before do
            get :new, params: order_params(activity_id: @activity.id)
            end
          it_behaves_like 'a successful request'
        end
      end
    end

    def order_params(overrides={})
      {
        activity_id: overrides[:activity_id],
        date: '4/10/2016',
        time_slots: { '1': ["01:00:00, 02:00:00"] }
      }
    end
  end

  describe 'POST create' do
    context 'a reservable and reservable options are exist' do
      before do
        @reservable = create(:reservable)
        @option_1 = ReservableOption.create(
          name: 'bumper',
          reservable_type: 'Lane'
        )
        @option_2 = ReservableOption.create(
          name: 'handicap_accessible',
          reservable_type: 'Lane'
        )
      end

      context 'user is logged in' do
        login_user
        context 'all params are valid' do
          it 'creates a booking' do
            post :create, params: order_params(user_id: @user.id)

            expect(Order.count).to eq 1
            expect(Order.first.user).to eq @user
            expect(Order.first.guest_first_name).to eq ''
            expect(Order.first.guest_last_name).to eq ''
            expect(Order.first.guest_email).to eq ''

            bookings = Order.first.bookings
            expect(bookings.length).to eq 1
            expect(bookings.first.start_time.to_s).to match '08:00:00'
            expect(bookings.first.end_time.to_s).to match '09:00:00'
            expect(bookings.first.reservable_options.size).to eq 2
            expect(response).to redirect_to orders_success_path
          end
        end
      end

      context 'user is not logged in' do
        before { @user = create(:user, email: 'guest_user@gmail.com') }
        it 'creates a booking' do
          post :create, params: order_params(
            user_id: @user.id,
            guest_first_name: 'peter',
            guest_last_name: 'pan',
            guest_email: 'peter-pan@gmail.com'
          )

          expect(Order.count).to eq 1
          expect(Order.first.user).to eq @user
          expect(Order.first.guest_first_name).to eq 'peter'
          expect(Order.first.guest_last_name).to eq 'pan'
          expect(Order.first.guest_email).to eq 'peter-pan@gmail.com'

          bookings = Order.first.bookings
          expect(bookings.length).to eq 1
          expect(bookings.first.start_time.to_s).to match '08:00:00'
          expect(bookings.first.end_time.to_s).to match '09:00:00'
          expect(bookings.first.reservable_options.size).to eq 2
          expect(response).to redirect_to orders_success_path
        end
      end
    end
  end

  def order_params(overrides={})
    {
      order: {
        user_id: overrides[:user_id],
        activity_id: @reservable.activity.id,
        guest_first_name: overrides[:guest_first_name] || '',
        guest_last_name: overrides[:guest_last_name] || '',
        guest_email: overrides[:guest_email] || '',
        bookings_attributes: [
          {
            start_time: '08:00:00',
            end_time: '09:00:00',
            reservable_id: @reservable.id,
            booking_date: '4/10/2016',
            number_of_players: '1',
            reservable_options_attributes: [
              { reservable_option_id: @option_1.id },
              { reservable_option_id: @option_2.id }
            ]
          }
        ]
      },
      token_id: 'tokenId12345'
    }
  end
end
