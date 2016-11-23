describe Admin::BusinessesController do
  describe "GET export_bookings" do
    context 'user has admin privilege' do
      before do
        @user = create(:user, admin: true)
        sign_in @user
      end
      context 'business exists' do
        before do
          @business = create(:business)
        end
        it 'returns an excel file' do
          get :export_bookings, params: { id: @business.id, format: 'xls' }
          expect(response.status).to eq 200
          expect(response.headers['Content-Type']).to match 'application/xls'
        end
      end
    end

    context 'user does not have admin privilege' do
      before do
        @user = create(:user, admin: false)
        sign_in @user
      end
      context 'business exists' do
        before do
          @business = create(:business)
        end
        it 'redirects to root path and shows error' do
          get :export_bookings, params: { id: @business.id, format: 'xls' }
          expect(response).to redirect_to root_path
          expect(flash[:alert])
            .to match "You don't have privilege to access admin page"
        end
      end
    end
  end

end
