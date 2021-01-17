# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use jbuilder for easier JSON API creation
gem 'jbuilder', '~> 2.7'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS)
gem 'rack-cors', '~> 1.1'

# Use PostgreSQL for production database
gem 'pg', '~> 1.2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'

# Use Devise for user authentication
gem 'devise', '~> 4.7'
# Use CanCanCan for user authorization
gem 'cancancan', '~> 3.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.1', platforms: %i[mri mingw x64_mingw]
  # Use rspec with extensions for unit testing
  gem 'rspec', '~> 3.9'
  gem 'rspec-rails', '~> 4.0'
  # Use rubocop for linting
  gem 'rubocop', '~> 1.8', require: false
  gem 'rubocop-rails', '~> 2.9', require: false
  gem 'rubocop-rspec', '~> 2.1', require: false
  # Use simplecov for test coverage viewing
  gem 'simplecov', '~> 0.21', require: false
end

group :development do
  gem 'listen', '~> 3.3'
  # Use spring for development speed up
  gem 'spring', '~> 2.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2020', platforms: %i[mingw mswin x64_mingw jruby]
