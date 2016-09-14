include Warden::Test::Helpers
RSpec.shared_context 'logged in user' do
  background do
    Warden.test_mode!
    login_as(@user, :scope => :user)
  end
  after(:each) do
    Warden.test_reset!
  end
end
