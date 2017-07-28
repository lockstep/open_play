describe Report::BusinessesController do
  describe 'GET index' do
    context 'user is logged in' do
      login_user
      context 'user is an admin' do
        before do
          @user.update(admin: true)
          get :index
        end
        it_behaves_like 'a successful request'
      end

      context 'user is not an admin' do
        before { get :index }
        it_behaves_like 'an unauthorized request'
      end
    end

    context 'user is not logged in' do
      before { get :index }
      it_behaves_like 'it requires authentication'
    end
  end
end
