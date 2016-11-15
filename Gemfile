source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'bootstrap', '~> 4.0.0.alpha3'
gem "font-awesome-rails"
# Use moment.js as the advanced formatting for Pikaday(datepicker library)
gem 'momentjs-rails'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

gem 'paperclip', '~> 4.3'
gem 'aws-sdk-v1'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'airbrake'
gem 'rack-timeout'
gem 'sidekiq'
gem 'devise', '~> 4.2.0'
gem "pundit" # Authorization system
gem 'stripe'
gem 'kaminari'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails'
  gem 'launchy'
end

group :test do
  gem 'webmock'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'poltergeist'
end

group :production do
  # Use Puma as the app server
  gem 'puma', '~> 3.0'
end

group :development do
  gem 'thin'
  # Access an IRB console on exception pages or by using <%= console %> anywhere
  # in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby '2.3.1'
