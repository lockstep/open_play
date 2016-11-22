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
        user = User.first
        expect(user.first_name).to eq('jame')
        expect(user.last_name).to eq('gosling')
        expect(user.phone_number).to eq('+1 650-253-0000')
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
        first_name: 'jame',
        last_name: 'gosling',
        phone_number: '+1 650-253-0000'
      }
    }
  end
end
