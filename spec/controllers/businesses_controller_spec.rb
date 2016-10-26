describe BusinessesController do
  describe 'GET new' do
    context 'user is logged in' do
      login_user
      before { get :new }
      it_behaves_like 'a successful request'
    end

    context 'user is not logged in' do
      before { get :new }
      it_behaves_like 'it requires authentication'
    end
  end

  describe 'POST create' do
    context 'user is logged in' do
      login_user
      it 'creates a business' do
        post :create, params: business_params
        expect(Business.count).to eq 1
        expect(Business.first.name).to eq 'Dream world'
      end
    end
    context 'user is not logged in' do
      before { post :create, params: business_params }
      it_behaves_like 'it requires authentication'
    end
  end

  def business_params
    {
      business: {
        name: 'Dream world',
        description: 'Dream World is the amusement park for kids!'
      }
    }
  end
end
