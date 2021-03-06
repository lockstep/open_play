describe OrdersController do
  describe 'GET new' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'an activity exists' do
        before { @activity = create(:bowling, business: @business) }

        context 'user is logged in' do
          login_user
          before do
            expect_any_instance_of(Order).to receive(:set_price_of_bookings)
            @business.update(user: @user)
            get :new, params: {
              activity_id: @activity.id,
              date: '4/10/2016',
              time_slots: { '1': ["01:00:00, 02:00:00"] }
            }
          end
          it_behaves_like 'a successful request'
        end
        context 'user is not logged in' do
          before do
            expect_any_instance_of(Order).to receive(:set_price_of_bookings)
            get :new, params: {
              activity_id: @activity.id,
              date: '4/10/2016',
              time_slots: { '1': ["01:00:00, 02:00:00"] }
            }
          end
          it_behaves_like 'a successful request'
        end
      end
    end
  end

  describe 'GET prepare_complete_order' do
    context 'a lane exists' do
      before do
        @business = create(:business)
        @bowling = create(:bowling, business: @business)
        @lane = create(:lane, activity: @bowling)
        @option_1 = ReservableOption.create(
          name: 'bumper', reservable_type: 'Lane')
        @option_2 = ReservableOption.create(
          name: 'handicap_accessible', reservable_type: 'Lane' )
      end
      context 'a valid order' do
        context 'user is logged in' do
          login_user
          context 'user is a business owner' do
            before { @business.update(user: @user) }
            it 'returns correct metadata' do
              @user.update(email: 'elon_musk@tesls.com')
              params = user_order_params(
                activity_id: @bowling.id,
                reservable_id: @lane.id,
                option_1_id: @option_1.id,
                option_2_id: @option_2.id
              )

              get :prepare_complete_order, params: params
              response_data = JSON.parse(response.body)['meta']
              expect(response_data['number_of_bookings']).to eq 1
              expect(response_data['total_price_cents']).to eq 0
              expect(response_data['email']).to eq 'elon_musk@tesls.com'
            end
          end
          context 'user is not a business owner' do
            it 'returns correct metadata' do
              @user.update(email: 'elon_musk@tesls.com')
              params = user_order_params(
                activity_id: @bowling.id,
                reservable_id: @lane.id,
                option_1_id: @option_1.id,
                option_2_id: @option_2.id
              )

              get :prepare_complete_order, params: params
              response_data = JSON.parse(response.body)['meta']
              expect(response_data['number_of_bookings']).to eq 1
              expect(response_data['total_price_cents']).to eq 2100
              expect(response_data['email']).to eq 'elon_musk@tesls.com'
            end
          end
        end
        context 'user is not logged in (guest)' do
          context 'guest params are valid' do
            it 'returns correct metadata' do
              params = guest_order_params(
                activity_id: @bowling.id,
                reservable_id: @lane.id,
                option_1_id: @option_1.id,
                option_2_id: @option_2.id,
                email: 'mark@facebook.com'
              )
              get :prepare_complete_order, params: params
              response_data = JSON.parse(response.body)['meta']
              expect(response_data['number_of_bookings']).to eq 1
              expect(response_data['total_price_cents']).to eq 2100
              expect(response_data['email']).to eq 'mark@facebook.com'
            end
          end
        end
      end
      context 'an invalid order' do
        it 'is handled gracefully' do
          params = guest_order_params(
            activity_id: @bowling.id,
            reservable_id: @lane.id,
            option_1_id: @option_1.id,
            option_2_id: @option_2.id,
            email: 'mark@facebook.com',
            number_of_players: 0
          )
          get :prepare_complete_order, params: params
          error = JSON.parse(response.body)['meta']['errors'].first
          expect(error).to match "Bookings number of players must be greater than 0"
        end
      end
    end
  end

  describe 'GET get_order_prices' do
    context 'a lane exists' do
      before do
        @business = create(:business)
        @bowling = create(:bowling, business: @business)
        @lane = create(:lane, activity: @bowling)
      end

      context 'user is logged in' do
        login_user
        context 'user is a business owner' do
          before { @business.update(user: @user) }

          it 'returns correct metadata' do
            params = user_order_params(
              activity_id: @bowling.id,
              reservable_id: @lane.id
            )
            get :get_order_prices, params: params
            response_data = JSON.parse(response.body)['meta']
            expect(response_data['sub_total_price']).to eq 0
            expect(response_data['total_price']).to eq 0
          end
        end

        context 'user is not a business owner' do
          it 'returns correct metadata' do
            params = user_order_params(
              activity_id: @bowling.id,
              reservable_id: @lane.id
            )
            get :get_order_prices, params: params
            response_data = JSON.parse(response.body)['meta']
            expect(response_data['sub_total_price']).to eq 20.0
            expect(response_data['total_price']).to eq 21.0
          end
        end
      end

      context 'user is not logged in' do
        it 'returns correct metadata' do
          params = guest_order_params(
            activity_id: @bowling.id,
            reservable_id: @lane.id,
            first_name: '',
            last_name: '',
            email: '',
            phone_number: ''
          )
          get :get_order_prices, params: params
          response_data = JSON.parse(response.body)['meta']
          expect(response_data['sub_total_price']).to eq 20.0
          expect(response_data['total_price']).to eq 21.0
        end
      end
    end
  end

  describe 'POST create' do
    context 'a reservable exists' do
      before do
        @business = create(:business)
        @activity = create(:bowling, business: @business)
        @reservable = create(:reservable, activity: @activity)
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
        context 'user is not a business owner' do
          it 'creates a booking' do
            expect(StripeCharger).to receive(:charge).with(
              an_instance_of(Money), String).and_return(149)
            expect(SendConfirmationOrderService).to receive(:call).with(
              hash_including(order: an_instance_of(Order),
                             confirmation_channel: 'email')
            )


            post :create, params: user_order_params(
              activity_id: @activity.id,
              reservable_id: @reservable.id,
              option_1_id: @option_1.id,
              option_2_id: @option_2.id,
              token_id: 'tokenId12345'
            )

            expect(Order.count).to eq 1
            order = Order.first
            expect(order.price_cents).to eq 2100
            bookings = order.bookings
            expect(bookings.length).to eq 1
            expect(bookings.first.start_time.to_s).to match '08:00:00'
            expect(bookings.first.end_time.to_s).to match '09:00:00'
            expect(bookings.first.reservable_options.size).to eq 2
            expect(bookings.first.booking_price_cents).to eq 2000
            expect(bookings.first.paid_externally).to eq false
            expect(response).to redirect_to success_order_path(Order.last)
          end
        end
        context 'user is a business owner' do
          before { @business.update(user: @user) }
          it 'creates a booking' do
            expect(StripeCharger).to_not receive(:charge).with(
              an_instance_of(Money), String
            )
            expect(SendConfirmationOrderService).to receive(:call).with(
              hash_including(order: an_instance_of(Order),
                             confirmation_channel: 'email')
            )

            post :create, params: user_order_params(
              activity_id: @activity.id,
              reservable_id: @reservable.id,
              option_1_id: @option_1.id,
              option_2_id: @option_2.id,
              token_id: 'tokenId12345'
            )

            expect(Order.count).to eq 1
            order = Order.first
            expect(order.total_price).to eq 0
            bookings = order.bookings
            expect(bookings.length).to eq 1
            expect(bookings.first.start_time.to_s).to match '08:00:00'
            expect(bookings.first.end_time.to_s).to match '09:00:00'
            expect(bookings.first.reservable_options.size).to eq 2
            expect(bookings.first.booking_price).to eq 0
            expect(bookings.first.paid_externally).to eq true
            expect(response).to redirect_to business_path(@business.id)
          end
        end
      end
      context 'user is not logged in (guest user)' do
        it 'creates a booking' do
          expect(StripeCharger).to receive(:charge).and_return(150)
          expect(SendConfirmationOrderService).to receive(:call).with(
            hash_including(order: an_instance_of(Order),
                           confirmation_channel: 'email')
          )

          post :create, params: guest_order_params(
            activity_id: @activity.id,
            reservable_id: @reservable.id,
            option_1_id: @option_1.id,
            option_2_id: @option_2.id,
            email: 'mark@facebook.com',
            token_id: 'tokenId12345'
          )

          expect(Order.count).to eq 1
          order = Order.first
          expect(order.price_cents).to eq 2100
          bookings = order.bookings
          expect(bookings.length).to eq 1
          expect(bookings.first.start_time.to_s).to match '08:00:00'
          expect(bookings.first.end_time.to_s).to match '09:00:00'
          expect(bookings.first.reservable_options.size).to eq 2
          expect(bookings.first.booking_price_cents).to eq 2000
          expect(bookings.first.paid_externally).to eq false
          expect(response).to redirect_to success_order_path(Order.last)
        end
      end
    end
  end

  describe 'GET reservations_for_business_owner' do
    context 'an activity exists' do
      before do
        @business = create(:business)
        @activity = create(:bowling, business: @business)
      end
      context 'user is logged in' do
        login_user
        context 'user is a business owner' do
          before do
            @business.update(user: @user)
            get :reservations_for_business_owner, params: {
              activity_id: @activity.id, booking_date: '4/10/2016'
            }
          end
          it_behaves_like 'a successful request'
        end
        context 'user is not a business owner' do
          before do
            get :reservations_for_business_owner, params: {
              activity_id: @activity.id, booking_date: '4/10/2016'
            }
          end
          it_behaves_like 'an unauthorized request'
        end
      end
      context 'user is not logged in' do
        before do
          get :reservations_for_business_owner, params: {
            activity_id: @activity.id, booking_date: '4/10/2016'
          }
        end
        it_behaves_like 'it requires authentication'
      end
    end
  end

  describe 'GET reservations_for_users' do
    context 'user is logged in' do
      login_user
      context 'reservations of user' do
        before do
          get :reservations_for_users, params: {
            user_id: @user.id, booking_date: '4/10/2016'
          }
        end
        it_behaves_like 'a successful request'
      end
      context 'reservations of others user' do
        before do
          user = create(:user)
          get :reservations_for_users, params: {
            user_id: user, booking_date: '4/10/2016'
          }
        end
        it_behaves_like 'an unauthorized request'
      end
    end
    context 'user is not logged in' do
      before do
        user = create(:user)
        get :reservations_for_users, params: {
          user_id: user, booking_date: '4/10/2016'
        }
      end
      it_behaves_like 'it requires authentication'
    end
  end

  describe 'GET check_payment_requirement' do
    before do
      @business = create(:business)
      @bowling = create(:bowling, business: @business)
      @reservable = create(:reservable, activity: @bowling)
    end

    context 'user is logged in' do
      login_user

      context 'user is a business owner' do
        before do
          @business.update(user: @user)
          get :check_payment_requirement, params: { order: { activity_id: @bowling.id }}
        end
        it_behaves_like 'a successful request'

        it 'returns correct result' do
          response_data = JSON.parse(response.body)['meta']
          expect(response_data['is_required']).to eq false
        end
      end

      context 'user is not a business owner' do
        before do
          get :check_payment_requirement, params: { order: { activity_id: @bowling.id }}
        end
        it_behaves_like 'a successful request'

        it 'returns correct result' do
          response_data = JSON.parse(response.body)['meta']
          expect(response_data['is_required']).to eq true
        end
      end
    end

    context 'user is not logged in' do
      before do
        get :check_payment_requirement, params: { order: { activity_id: @bowling.id }}
      end
      it_behaves_like 'a successful request'

      it 'returns correct result' do
        response_data = JSON.parse(response.body)['meta']
        expect(response_data['is_required']).to eq true
      end
    end
  end

  def user_order_params(overrides={})
    {
      order: {
        activity_id: overrides[:activity_id],
        bookings_attributes: [
          {
            start_time: '08:00:00',
            end_time: '09:00:00',
            reservable_id: overrides[:reservable_id],
            booking_date: '4/10/2016',
            number_of_players: '1',
            reservable_options_attributes: [
              { reservable_option_id: overrides[:option_1_id] },
              { reservable_option_id: overrides[:option_2_id] }
            ]
          }
        ]
      },
      token_id: overrides[:token_id] || '',
      confirmation_channel: overrides[:channel] || 'email'
    }
  end

  def guest_order_params(overrides={})
    {
      order: {
        activity_id: overrides[:activity_id],
        bookings_attributes: [
          {
            start_time: '08:00:00',
            end_time: '09:00:00',
            reservable_id: overrides[:reservable_id],
            booking_date: '4/10/2016',
            number_of_players: overrides[:number_of_players] || '1',
            reservable_options_attributes: [
              { reservable_option_id: overrides[:option_1_id] },
              { reservable_option_id: overrides[:option_2_id] }
            ]
          }
        ]
      },
      guest: {
        first_name: overrides[:first_name] || 'mark',
        last_name: overrides[:last_name] || 'zuckerberg',
        email: overrides[:email],
        phone_number: overrides[:phone_number] || '+1 650-253-0000'
      },
      token_id: overrides[:token_id] || '',
      confirmation_channel: overrides[:channel] || 'email'
    }
  end
end
