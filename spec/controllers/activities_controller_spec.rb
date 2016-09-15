describe ActivitiesController do
  describe 'GET index' do
    context 'user is logged in' do
      login_user
      before do
        @business = create(:business, user: @user)
        get :index, params: { business_id: @business.id }
      end
      it_behaves_like 'a successful request'
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
end
