describe OrdersController do
  describe 'GET new' do
    context 'user is logged in' do
      login_user
      before do
        get :new, params: {
          date: '4/10/2016',
          time_slots: { '1': ["01:00:00,02:00:00"] }
        }
      end
      it_behaves_like 'a successful request'
    end

    context 'user is not logged in' do
      before { get :new }
      it_behaves_like 'it requires authentication'
    end
  end

  describe 'POST create' do
    before do
      @first_reservable = create(:reservable)
      @second_reservable = create(:reservable, name: 'Item 2')
    end

    context 'user is logged in' do
      login_user
      context 'all params are valid' do
        it 'creates a booking' do
          post :create, params: order_params(
            first_reservable: @first_reservable.id,
            second_reservable: @second_reservable.id
          )
          expect(Order.count).to eq 1
          bookings = Order.first.bookings
          expect(bookings.length).to eq 1
          expect(bookings.first.start_time.to_s).to match '08:00:00'
          expect(bookings.first.end_time.to_s).to match '09:00:00'
          expect(response).to redirect_to orders_success_path
        end
      end
    end

    context 'user is not logged in' do
      before do
        post :create, params: order_params(
          first_reservable: @first_reservable.id,
          second_reservable: @second_reservable.id
        )
      end
      it_behaves_like 'it requires authentication'
    end
  end

  def order_params(overrides={})
    {
      order: {
        bookings_attributes: [
          {
           start_time: '08:00:00',
           end_time: '09:00:00',
           reservable_id: overrides[:first_reservable],
           booking_date: '4/10/2016',
           number_of_players: '1'
          }
        ]
      }
    }
  end
end
