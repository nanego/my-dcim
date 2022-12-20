# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip
gem 'rails', '~> 6.0.x'

gem 'administrate'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'nokogiri', '~> 1.13', '>= 1.13.6'
gem 'rails-i18n'
gem 'sassc-rails', '~> 2.0'
gem 'sprockets', '~>3.0'
gem 'uglifier', '>= 1.3.0'

gem 'bootstrap-sass', '>= 3.4.1'
gem 'bourbon'
# gem 'bootstrap-generators', git: 'git://github.com/decioferreira/bootstrap-generators.git'
gem 'bootstrap-generators', '~> 3.3.4'

# Authentication
gem 'devise'
gem 'devise-i18n'
gem 'devise_invitable'
gem 'omniauth', '>= 1.1.1'
gem 'omniauth-cas', '= 1.1.1'
gem 'simple_token_authentication', '~> 1.0'

gem 'datagrid'
gem 'faraday'
gem 'high_voltage'
gem 'kaminari'
gem 'pg'
gem 'simple_form'
gem 'virtus'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use ActiveStorage variant
gem 'image_processing', '~> 1.2'

group :development do
  gem 'web-console', '~> 2.0'
  gem 'better_errors'
  # gem 'quiet_assets'
  gem 'listen', '~> 3.2'
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
  gem 'rails-controller-testing'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'simplecov', require: false
end
group :test do
  # gem 'minitest-rails-capybara'
  gem 'capybara', '>= 2.15'
end
group :production do
  gem 'passenger'
  # gem 'therubyracer'
end
gem 'acts_as_list'
gem 'friendly_id', '~> 5.2'
gem 'public_activity', git: 'https://github.com/pokonski/public_activity.git'
gem 'record_tag_helper', '~> 1.0' # Add helpers removed from Rails core in Rails 5
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# Manage file uploads
gem 'shrine', '~> 2.9'

# Add email notifications on errors
gem 'exception_notification'
gem 'letter_opener', group: :development

# Geocode Sites positions
gem 'geocoder'
