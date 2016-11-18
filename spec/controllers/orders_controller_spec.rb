describe OrdersController do
  include ActiveJob::TestHelper
  describe 'GET new' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'an activity exists' do
        before { @activity = create(:bowling, business: @business) }
        context 'user is logged in' do
          login_user
          before do
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
    context 'user is not logged in' do
      context 'guest param is missing' do
        it 'is handled gracefully' do
          params = order_params
          params.delete(:guest)
          get :prepare_complete_order, params: params
          error = JSON.parse(response.body)['meta']['errors'].first
          expect(error).to match 'First name'
        end
      end
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
            expect { post :create, params: order_params(user_id: @user.id)}
              .to change { enqueued_jobs.size }.by(1)

            expect(enqueued_jobs.last[:job]).to eq ActionMailer::DeliveryJob
            expect(Order.count).to eq 1
            bookings = Order.first.bookings
            expect(bookings.length).to eq 1
            expect(bookings.first.start_time.to_s).to match '08:00:00'
            expect(bookings.first.end_time.to_s).to match '09:00:00'
            expect(bookings.first.reservable_options.size).to eq 2
            expect(bookings.first.booking_price).to eq 20.0
            expect(response).to redirect_to success_order_path(Order.last)
          end
        end
      end

    end
  end

  def order_params(overrides={})
    {
      order: {
        user_id: overrides[:user_id],
        activity_id: @reservable.activity.id,
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
      guest: {
        first_name: 'test', last_name: 'test', email: 'test@example.com'
      },
      token_id: 'tokenId12345'
    }
  end
end
