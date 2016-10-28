describe ReservablesController do
  describe 'GET new' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'a laser_tag exists' do
        before { @laser_tag = create(:laser_tag, business: @business) }
        context 'user is logged in' do
          login_user
          context 'user is a business owner' do
            before do
              @business.update(user: @user)
              get :new, params: { activity_id: @laser_tag.id }
            end
            it_behaves_like 'a successful request'
          end
          context 'user is not a business owner' do
            before { get :new, params: { activity_id: @laser_tag.id } }
            it_behaves_like 'an unauthorized request'
          end
        end
        context 'user is not logged in' do
          before { get :new, params: { activity_id: @laser_tag.id } }
          it_behaves_like 'it requires authentication'
        end
      end

      context 'a bowling exists' do
        before { @bowling = create(:bowling, business: @business) }
        context 'user is logged in' do
          login_user
          context 'user is a business owner' do
            before do
              @business.update(user: @user)
              get :new, params: { activity_id: @bowling.id }
            end
            it_behaves_like 'a successful request'
          end
          context 'user is not a business owner' do
            before { get :new, params: { activity_id: @bowling.id } }
            it_behaves_like 'an unauthorized request'
          end
        end
        context 'user is not logged in' do
          before { get :new, params: { activity_id: @bowling.id } }
          it_behaves_like 'it requires authentication'
        end
      end
    end
  end

  describe 'POST create' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'a laser_tag exists' do
        before { @laser_tag = create(:laser_tag, business: @business) }
        context 'user is logged in' do
          login_user
          context 'user is a business owner' do
            before { @business.update(user: @user) }
            it 'creates a room' do
              create_a_room

              expect(Reservable.count).to eq 1
              reservable = Reservable.first
              expect(reservable.name).to eq 'kitty'
              expect(reservable.interval).to eq 60
              expect(reservable.start_time.to_s).to match '08:00'
              expect(reservable.end_time.to_s).to match '16:00'
              expect(reservable.maximum_players).to eq 30
              expect(reservable.weekday_price).to eq 15
              expect(reservable.weekend_price).to eq 20
            end
          end
          context 'user is not a business owner' do
            before { create_a_room }
            it_behaves_like 'an unauthorized request'
          end
        end

        context 'user is not logged in' do
          before { create_a_room }
          it_behaves_like 'it requires authentication'
        end

        def create_a_room
          post :create, params: {
            activity_id: @laser_tag.id,
            room: {
              name: 'kitty',
              interval: 60,
              start_time: '08:00:00.000',
              end_time: '16:00:00.000',
              maximum_players: 30,
              weekday_price: 15,
              weekend_price: 20
            }
          }
        end
      end

      context 'a bowling exists' do
        before { @bowling = create(:bowling, business: @business) }
        context 'user is logged in' do
          login_user
          context 'user is a business owner' do
            before { @business.update(user: @user) }
            it 'creates a lane' do
              create_a_lane

              expect(Reservable.count).to eq 1
              reservable = Reservable.first
              expect(reservable.name).to eq 'kitty'
              expect(reservable.interval).to eq 60
              expect(reservable.start_time.to_s).to match '08:00'
              expect(reservable.end_time.to_s).to match '16:00'
              expect(reservable.maximum_players).to eq 30
              expect(reservable.weekday_price).to eq 15
              expect(reservable.weekend_price).to eq 20
            end
          end
          context 'user is not a business owner' do
            before { create_a_lane }
            it_behaves_like 'an unauthorized request'
          end
        end
        context 'user is not logged in' do
          before { create_a_lane }
          it_behaves_like 'it requires authentication'
        end
      end

      def create_a_lane
        post :create, params: {
          activity_id: @bowling.id,
          lane: {
            name: 'kitty',
            interval: 60,
            start_time: '08:00:00.000',
            end_time: '16:00:00.000',
            maximum_players: 30,
            weekday_price: 15,
            weekend_price: 20
          }
        }
      end
    end
  end

  describe 'GET edit' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'a laser_tag exists' do
        before { @laser_tag = create(:laser_tag, business: @business) }
        context 'a room exists' do
          before { @room = create(:room, activity: @laser_tag) }
          context 'user is logged in' do
            login_user
            context 'user is a business owner' do
              before do
                @business.update(user: @user)
                get :edit, params: { id: @room }
              end
              it_behaves_like 'a successful request'
            end
            context 'user is not a business owner' do
              before { get :edit, params: { id: @room } }
              it_behaves_like 'an unauthorized request'
            end
          end
          context 'user is not logged in' do
            before { get :edit, params: { id: @room } }
            it_behaves_like 'it requires authentication'
          end
        end
      end

      context 'a bowling exists' do
        before { @bowling = create(:bowling, business: @business) }
        context 'a lane exists' do
          before { @lane = create(:lane, activity: @bowling) }
          context 'user is logged in' do
            login_user
            context 'user is a business owner' do
              before do
                @business.update(user: @user)
                get :edit, params: { id: @lane }
              end
              it_behaves_like 'a successful request'
            end
            context 'user is not a business owner' do
              before { get :edit, params: { id: @lane } }
              it_behaves_like 'an unauthorized request'
            end
          end
          context 'user is not logged in' do
            before { get :edit, params: { id: @lane } }
            it_behaves_like 'it requires authentication'
          end
        end
      end
    end
  end

  describe 'PATCH update' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'a laser_tag exists' do
        before { @laser_tag = create(:laser_tag, business: @business) }
        context 'a room exists' do
          before { @room = create(:room, activity: @laser_tag) }
          context 'user is logged in' do
            login_user
            context 'user is a business owner' do
              before { @business.update(user: @user) }
              it 'updates a room' do
                patch :update, params: { id: @room, room: { name: 'Death Room 123'} }
                expect(Reservable.count).to eq 1
                expect(Reservable.first.reload.name).to eq 'Death Room 123'
              end
            end
            context 'user is not a business owner' do
              before do
                patch :update, params: { id: @room, room: { name: 'Death Room 123'} }
              end
              it_behaves_like 'an unauthorized request'
            end
          end
          context 'user is not logged in' do
            before do
              patch :update, params: { id: @room, room: { name: 'Death Room 123'} }
            end
            it_behaves_like 'it requires authentication'
          end
        end
      end

      context 'a bowling exists' do
        before { @bowling = create(:bowling, business: @business) }
        context 'a lane exists' do
          before { @lane = create(:lane, activity: @bowling) }
          context 'user is logged in' do
            login_user
            context 'user is a business owner' do
              before { @business.update(user: @user) }
              it 'updates a lane' do
                patch :update, params: { id: @lane, lane: { name: 'Death Room 123'} }
                expect(Reservable.count).to eq 1
                expect(Reservable.first.reload.name).to eq 'Death Room 123'
              end
            end
            context 'user is not a business owner' do
              before do
                patch :update, params: { id: @lane, lane: { name: 'Death Room 123'} }
              end
              it_behaves_like 'an unauthorized request'
            end
          end
          context 'user is not logged in' do
            before do
              patch :update, params: { id: @lane, lane: { name: 'Death Room 123'} }
            end
            it_behaves_like 'it requires authentication'
          end
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'a laser_tag exists' do
        before { @laser_tag = create(:laser_tag, business: @business) }
        context 'a room exists' do
          before { @room = create(:room, activity: @laser_tag) }
          context 'user is logged in' do
            login_user
            context 'user is a business owner' do
              before { @business.update(user: @user) }
              it 'destroy a room(archived)' do
                delete :destroy, params: { id: @room }
                expect(Reservable.count).to eq 1
                expect(Reservable.first.reload.archived).to be_truthy
              end
            end
            context 'user is not a business owner' do
              before { delete :destroy, params: { id: @room } }
              it_behaves_like 'an unauthorized request'
            end
          end
          context 'user is not logged in' do
            before { delete :destroy, params: { id: @room } }
            it_behaves_like 'it requires authentication'
          end
        end
      end

      context 'a bowling exists' do
        before { @bowling = create(:bowling, business: @business) }
        context 'a lane exists' do
          before { @lane = create(:lane, activity: @bowling) }
          context 'user is logged in' do
            login_user
            context 'user is a business owner' do
              before { @business.update(user: @user) }
              it 'destroy a lane(archived)' do
                delete :destroy, params: { id: @lane }
                expect(Reservable.count).to eq 1
                expect(Reservable.first.reload.archived).to be_truthy
              end
            end
            context 'user is not a business owner' do
              before { delete :destroy, params: { id: @lane } }
              it_behaves_like 'an unauthorized request'
            end
          end
          context 'user is not logged in' do
            before { delete :destroy, params: { id: @lane } }
            it_behaves_like 'it requires authentication'
          end
        end
      end
    end
  end
end
