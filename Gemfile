# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.1'
# Use unicorn as production server
gem 'listen', '3.4.1'
gem 'unicorn', '5.8.0'
# Use Rack Timeout for handling hanging clients in production
gem 'rack-timeout', '0.6.0'
# Use jbuilder for easier JSON API creation
gem 'jbuilder', '2.11.2'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '1.6.0', require: false
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS)
gem 'rack-cors', '1.1.1'

# Use PostgreSQL for production database
gem 'pg', '1.2.3'

# Allow has_secure_password
gem 'bcrypt', '3.1.16'
# Better indexes
gem 'ksuid', '0.2.0'
# Use CanCanCan for user authorization
gem 'cancancan', '3.2.1'

group :development, :test do
  # Use Puma as the app server
  gem 'puma', '5.2.0'
  # Use sqlite3 as the development database
  gem 'sqlite3', '1.4.2'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '11.1.3', platforms: %i[mri mingw x64_mingw]
  # Use rspec with extensions for unit testing
  gem 'rspec', '3.10.0', require: false
  gem 'rspec-rails', '4.0.2'
  # Use factory_bot_rails for defining and using factories
  gem 'factory_bot_rails', '6.1.0'
  # Use ffaker to generate fake data for unit testing
  gem 'ffaker', '2.17.0'
  # Use rubocop for linting
  gem 'rubocop', '1.8.1', require: false
  gem 'rubocop-rails', '2.9.1', require: false
  gem 'rubocop-rspec', '2.1.0', require: false
  # Use simplecov for test coverage viewing
  gem 'simplecov', '0.21.2', require: false
  # Maintain database consistency
  gem 'database_consistency', require: false
end

group :development do
  # Use spring for development speed up
  gem 'spring', '2.1.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '1.2021.1', platforms: %i[mingw mswin x64_mingw jruby]
