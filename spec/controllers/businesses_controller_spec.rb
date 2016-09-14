describe BusinessesController do
  describe 'POST create' do
    context 'user is logged in' do
      login_user
      it 'creates a buiness and redirect to list of activities' do
        post :create, params: business_params
        expect(Business.count).to eq 1
        expect(Business.first.name).to eq 'Dream world'
        expect(response).to redirect_to activities_path
      end
    end

    context 'user is not logged in' do
      before { post :create, params: business_params }
      it_behaves_like 'it requires authentication'
    end
  end

  def business_params
    { business: { name: 'Dream world', description: 'Dream World is the amusement park for kids!' } }
  end
end
