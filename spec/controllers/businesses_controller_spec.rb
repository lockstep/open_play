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

  describe 'GET show' do
    before { @business = create(:business) }

    context 'user is logged in' do
      login_user
      before { get :show, params: { id: @business.id } }
      it_behaves_like 'a successful request'
    end

    context 'user is not logged in' do
      before { get :show, params: { id: @business.id } }
      it_behaves_like 'a successful request'
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
    context 'user is logged in' do
      login_user

      before do
        allow_any_instance_of(Paperclip::Attachment).to receive(:save)
          .and_return(true)
        path = Rails.root.join('spec/support/fixtures/ruby.png')
        file = Rack::Test::UploadedFile.new(path, "image/png")
        params = business_params.merge(profile_image: file)
        post :create, params: params
      end

      it_behaves_like 'a successful redirect'
    end
  end

  describe 'GET edit' do
    before { @business = create(:business) }

    context 'user is logged in' do
      login_user

      context 'user is a business owner' do
        before do
          @business.update(user: @user)
          get :edit, params: { id: @business }
        end

        it_behaves_like 'a successful request'
      end

      context 'user is not a business owner' do
        before do
          get :edit, params: { id: @business }
        end

        it_behaves_like 'an unauthorized request'
      end
    end

    context 'user is not logged in' do
      before do
        get :edit, params: { id: @business }
      end
      it_behaves_like 'it requires authentication'
    end
  end

  describe 'PATCH update' do
    before { @business = create(:business) }

    context 'user is logged in' do
      login_user

      context 'user is a business owner' do
        before do
          @business.update(user: @user)
          patch :update, params: { id: @business, business: { name: 'hello' } }
        end
        it_behaves_like 'a successful redirect'
      end

      context 'user is not a business owner' do
        before do
          patch :update, params: { id: @business, business: { name: 'hello' } }
        end
        it_behaves_like 'an unauthorized request'
      end
    end

    context 'user is not logged in' do
      before do
        patch :update, params: { id: @business, business: { name: 'hello' } }
      end
      it_behaves_like 'it requires authentication'
    end
  end

  def business_params
    {
      business: {
        name: 'Dream world',
        phone_number: '1234567890',
        address_line_one: '123 Bangkok',
        description: 'Dream World is the amusement park for kids!'
      }
    }
  end
end
