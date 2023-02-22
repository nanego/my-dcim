# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip
gem 'rails', '~> 6.1.0'

gem 'administrate'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'nokogiri', '~> 1.13', '>= 1.13.6'
gem 'rails-i18n', '~> 6.0.x'
gem 'sassc-rails', '~> 2.0'
gem 'terser'
gem 'sprockets-rails'

gem 'bootstrap-sass', '>= 3.4.1'
gem 'bourbon'
# gem 'bootstrap-generators', git: 'git://github.com/decioferreira/bootstrap-generators.git'
# gem 'bootstrap-generators', '~> 3.3.4'

# Authentication
gem 'devise'
gem 'devise-i18n'
gem 'devise_invitable'
gem 'omniauth', '~> 1.9.0' # '~> 2.1.0'
gem 'omniauth-cas', '~> 2.0.0'
gem 'simple_token_authentication', '~> 1.0'

gem 'datagrid'
gem 'faraday'
gem 'high_voltage'
gem 'kaminari'
gem 'pg'
gem 'virtus'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use ActiveStorage variant
gem 'image_processing', '~> 1.2'

group :development do
  gem 'better_errors'
  gem "binding_of_caller", "~> 1.0"
  gem 'web-console', '>= 4.1.0'
  # gem 'quiet_assets'
  gem 'listen', '~> 3.3'
  gem 'meta_request'
  gem 'rails_layout'
end
group :development, :test do
  gem 'active_record_doctor'
  gem 'bullet'
  gem 'byebug'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'puma'
  gem 'rack-mini-profiler'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rake'

  # gem "formulaic"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4.0"
  gem "simplecov", require: false
  gem "simplecov-console", require: false
  # gem "sinatra", require: false
  # gem "vcr"
  # gem "webmock"
end

group :test do
  # gem 'minitest-rails-capybara'

  gem 'capybara', '>= 2.15'
  gem "shoulda-matchers", "~> 4.0"
end

group :production do
  gem 'mini_racer'
  gem 'passenger'
end

gem 'acts_as_list'
gem 'friendly_id', '~> 5.2'
gem 'public_activity'
gem 'record_tag_helper', '~> 1.0' # Add helpers removed from Rails core in Rails 5
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# Manage file uploads
gem 'shrine', '~> 3.0.x'

# Add email notifications on errors
gem 'exception_notification'
gem 'letter_opener', group: :development

# Geocode Sites positions
gem 'geocoder'

gem "importmap-rails", "~> 1.1"
gem "stimulus-rails", "~> 1.2"
