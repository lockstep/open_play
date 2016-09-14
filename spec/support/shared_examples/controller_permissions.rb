shared_examples 'it requires authentication' do
  it 'redirects to sign in' do
    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to match 'need to sign in or sign up'
  end
end

shared_examples 'an unauthorized request' do
  it 'redirects to root and flashes unauthorized' do
    expect(response).to redirect_to root_path
    expect(flash[:alert]).to match 'You are not authorized'
  end
end

shared_examples 'a successful request' do
  it 'responds with status 200' do
    expect(response.status).to eq(200)
  end
end

shared_examples 'a successful redirect' do
  it 'responds with status 302' do
    expect(response.status).to eq(302)
    expect(flash[:alert]).to be_nil
  end
end
