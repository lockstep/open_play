describe ReservablesController do
  describe 'GET new' do
    before do
      @laser_tag = create(:laser_tag)
    end

    context 'user is logged in' do
      login_user
      before { get :new, params: { activity_id: @laser_tag.id } }
      it_behaves_like 'a successful request'
    end

    context 'user is not logged in' do
      before { get :new, params: { activity_id: @laser_tag.id } }
      it_behaves_like 'it requires authentication'
    end
  end

  describe 'POST create' do
    before do
      @laser_tag = create(:laser_tag)
    end

    context 'user is logged in' do
      login_user
      context 'all params are valid' do
        it 'creates a booking' do
          post :create, params: {
            activity_id: @laser_tag.id,
            room: {
              name: 'kitty',
              interval: 60,
              start_time: '08:00:00.000',
              end_time: '16:00:00.000',
              maximum_players: 30
            }
          }

          expect(Reservable.count).to eq 1
          reservable = Reservable.first
          expect(reservable.name).to eq 'kitty'
          expect(reservable.interval).to eq 60
          expect(reservable.start_time.to_s).to match '08:00'
          expect(reservable.end_time.to_s).to match '16:00'
          expect(reservable.maximum_players).to eq 30
        end
      end
    end
  end
end
