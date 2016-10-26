describe ActivitiesController do
  describe 'GET index' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'user is logged in' do
        login_user
        context 'user is a business owner' do
          before do
            @business.update(user: @user)
            get :index, params: { business_id: @business.id }
          end
          it_behaves_like 'a successful request'
        end

        context 'user is not a business owner' do
          before { get :index, params: { business_id: @business.id } }
          it_behaves_like 'an unauthorized request'
        end
      end

      context 'user is not logged in' do
        before { get :index, params: { business_id: @business.id } }
        it_behaves_like 'it requires authentication'
      end
    end
  end

  describe 'GET new' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'user is logged in' do
        login_user
        context 'user is a business owner' do
          before do
            @business.update(user: @user)
            get :new, params: { business_id: @business.id }
          end
          it_behaves_like 'a successful request'
        end

        context 'user is not a business owner' do
          before { get :new, params: { business_id: @business.id } }
          it_behaves_like 'an unauthorized request'
        end
      end

      context 'user is not logged in' do
        before { get :new, params: { business_id: @business.id } }
        it_behaves_like 'it requires authentication'
      end
    end
  end

  describe 'POST create' do
    context 'a business exists' do
      before { @business = create(:business) }

      context 'user is logged in' do
        login_user
        context 'user is a business owner' do
          before { @business.update(user: @user) }
          it 'creates an activity' do
            post :create, params: activity_params.merge({ business_id: @business.id })

            expect(Activity.count).to eq 1
            activity = Activity.first
            expect(activity.type).to eq 'Bowling'
            expect(activity.name).to eq 'Country Club Lanes'
            expect(activity.start_time.to_s).to match '08:00:00'
            expect(activity.end_time.to_s).to match '16:00:00'
            expect(activity.prevent_back_to_back_booking).to eq true
            expect(activity.allow_multi_party_bookings).to eq true
            expect(response).to redirect_to business_activities_path
          end
        end

        context 'user is not a business owner' do
          before do
            post :create, params: activity_params.merge({ business_id: @business.id })
          end
          it_behaves_like 'an unauthorized request'
        end
      end

      context 'user is not logged in' do
        before do
          post :create, params: activity_params.merge({ business_id: @business.id })
        end
        it_behaves_like 'it requires authentication'
      end
    end
  end

  describe 'Get edit' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'an activity already exists' do
        before { @activity = create(:bowling, business: @business) }
        context 'user is logged in' do
          login_user
          context 'user is a business owner' do
            before do
              @business.update(user: @user)
              get :edit, params: { id: @activity }
            end
            it_behaves_like 'a successful request'
          end
          context 'user is not a business owner' do
            before { get :edit, params: { id: @activity } }
            it_behaves_like 'an unauthorized request'
          end
        end
        context 'user is not logged in' do
          before { get :edit, params: { id: @activity } }
          it_behaves_like 'it requires authentication'
        end
      end
    end
  end

  describe 'PATCH update' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'an activity already exists' do
        before { @activity = create(:bowling, business: @business) }
        context 'user is logged in' do
          login_user
          context 'user is a business owner' do
            before { @business.update(user: @user) }
            it 'updates an activity' do
              patch :update, params: { id: @activity, activity: { name: 'Super Bowl'} }
              expect(Activity.count).to eq 1
              expect(@activity.reload.type).to eq 'Bowling'
              expect(@activity.name).to eq 'Super Bowl'
              expect(response).to redirect_to business_activities_path(@activity.business)
            end
          end
          context 'user is not a business owner' do
            before do
              patch :update, params: { id: @activity, activity: { name: 'Super Bowl'} }
            end
            it_behaves_like 'an unauthorized request'
          end
        end
        context 'user is not logged in' do
          before do
            patch :update, params: { id: @activity, activity: { name: 'Super Bowl'} }
          end
          it_behaves_like 'it requires authentication'
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'an activity already exists' do
        before { @activity = create(:bowling, business: @business) }
        context 'user is logged in' do
          login_user
          context 'user is a business owner' do
            before { @business.update(user: @user) }
            it 'deletes an activity(archived)' do
              delete :destroy, params: { id: @activity }
              expect(Activity.count).to eq 1
              expect(@activity.reload.type).to eq 'Bowling'
              expect(@activity.archived).to be_truthy
            end
          end
          context 'user is not a business owner' do
            before { delete :destroy, params: { id: @activity } }
            it_behaves_like 'an unauthorized request'
          end
        end
        context 'user is not logged in' do
          before { delete :destroy, params: { id: @activity } }
          it_behaves_like 'it requires authentication'
        end
      end
    end
  end

  def activity_params
    {
      activity: {
        type: 'Bowling',
        name: 'Country Club Lanes',
        start_time: '8:00:00',
        end_time: '16:00:00',
        prevent_back_to_back_booking: true,
        allow_multi_party_bookings: true
      }
    }
  end
end
