describe UsersController do
  describe 'GET show' do
    context 'user is logged in' do
      login_user
      before { get :show, params: { id: @user.id } }
      it_behaves_like 'a successful request'
    end

    context 'user is not logged in' do
      before do
        user = create(:user)
        get :show, params: { id: user.id }
      end
      it_behaves_like 'it requires authentication'
    end
  end

  describe 'GET edit' do
    context 'user is logged in' do
      login_user
      before { get :edit, params: { id: @user.id } }
      it_behaves_like 'a successful request'
    end

    context 'user is not logged in' do
      before do
        user = create(:user)
        get :edit, params: { id: user.id }
      end
      it_behaves_like 'it requires authentication'
    end
  end

  describe 'PATCH update' do
    context 'user is logged in' do
      login_user
      it 'updates user profile successfully' do
        patch :update, params: user_params(id: @user.id)
        expect(User.first.email).to eq('hello@gmail.com')
      end
    end

    context 'user is not logged in' do
      before do
        user = create(:user)
        patch :update, params: user_params(id: user.id)
      end
      it_behaves_like 'it requires authentication'
    end
  end

  def user_params(overrides={})
    {
      id: overrides[:id],
      user: {
        email: 'hello@gmail.com'
      }
    }
  end
end
