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
    before do
      @user = create(:user)
      @business = create(:business, user: @user)
    end
    context 'user is not logged in' do
      before do
        post :create, params: activity_params.merge({ business_id: @business.id })
      end
      it_behaves_like 'it requires authentication'
    end
    context 'user is logged in' do
      login_user
      context 'empty activity type' do
        before do
          @invalid_params = activity_params(activity_type: '')
            .merge(
              { business_id: @business.id }
            )
        end
        it 'does not create the activity' do
          expect{ post :create, params: @invalid_params }
            .to_not change(Activity, :count)
        end
      end
    end
  end

  def activity_params(overrides={})
    {
      activity: {
        activity_type: overrides[:activity_type] || 'Bowling',
        name: 'Country Club Lanes',
        start_time: '8:00:00',
        end_time: '16:00:00'
      }
    }
  end
end
