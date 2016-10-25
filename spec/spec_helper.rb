ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
if Rails.env.production?
  abort("The Rails environment is running in production mode!")
end
require 'rspec/rails'
require 'capybara/poltergeist'
require 'webmock/rspec'
require 'sidekiq/testing'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
WebMock.disable_net_connect!(allow_localhost: true)
Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.run_all_when_everything_filtered = true
  config.fail_fast = true
  config.raise_errors_for_deprecations!
  config.expose_dsl_globally = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.syntax = :expect
  end

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  # config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed

  # Rails config

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Helpers

  config.include FactoryGirl::Syntax::Methods

  # Hooks

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before do |ex|
    # Set DatabaseCleaner strategy
    if ex.metadata[:db_strategy]
      DatabaseCleaner.strategy = ex.metadata[:db_strategy]
    else
      if Capybara.current_driver == :rack_test
        DatabaseCleaner.strategy = :transaction
      else
        DatabaseCleaner.strategy = :truncation
      end
    end
    DatabaseCleaner.start
    # Ensure Sidekiq testing mode is at default
    Sidekiq::Testing.fake!
    # Ensure mailer queue is clear
    ActionMailer::Base.deliveries.clear
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  # Devise helpers
  config.include Devise::Test::ControllerHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature

  config.before do
    stub_request(:post, "https://api.stripe.com/v1/charges")
      .with(body: {"amount": "2000", "currency": "usd", "source": "tokenId12345"})
      .to_return(status: 200, body: File.read(
        File.join('spec', 'support', 'fixtures', 'fake_requests', 'stripe',
        'create_charge.json')
    ))
  end

  config.include ActiveSupport::Testing::TimeHelpers
end
