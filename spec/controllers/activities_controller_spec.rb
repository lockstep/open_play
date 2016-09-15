describe ActivitiesController do
  describe 'GET index' do
    context 'user is logged in' do
      login_user
      context 'a business exists' do
        before do
          @business = create(:business, user: @user)
          get :index, params: { business_id: @business.id }
        end
        it_behaves_like 'a successful request'
      end
    end

    context 'user is not logged in' do
      before do
        @user = create(:user)
        @business = create(:business, user: @user)
        get :index, params: { business_id: @business.id }
      end
      it_behaves_like 'it requires authentication'
    end
  end

  describe 'GET new' do
    context 'user is logged in' do
      login_user
      context 'a business exists' do
        before do
          @business = create(:business, user: @user)
          get :new, params: { business_id: @business.id }
        end
        it_behaves_like 'a successful request'
      end
    end

    context 'user is not logged in' do
      before do
        @user = create(:user)
        @business = create(:business, user: @user)
        get :new, params: { business_id: @business.id }
      end
      it_behaves_like 'it requires authentication'
    end
  end

  describe 'POST create' do
    context 'user is logged in' do
      login_user
      context 'a business exists' do
        before do
          @business = create(:business, user: @user)
        end
        it 'creates an activity and redirect to show a list of activities' do
          post :create, params: activity_params.merge({ business_id: @business.id })
          expect(Activity.count).to eq 1
          expect(Activity.first.name).to eq 'Bowling'
          expect(response).to redirect_to business_activities_path
        end
      end
    end

    context 'user is not logged in' do
      before do
        @user = create(:user)
        @business = create(:business, user: @user)
        post :create, params: activity_params.merge({ business_id: @business.id })
      end
      it_behaves_like 'it requires authentication'
    end
  end

  def activity_params
    {
      activity: {
        name: 'Bowling',
        start_time: '8:00:00',
        end_time: '16:00:00'
      }
    }
  end
end
