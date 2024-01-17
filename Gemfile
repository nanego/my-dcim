# frozen_string_literal: true

source "https://rubygems.org"
ruby "3.2.2"
gem "rails", "~> 7.0.0"

gem "administrate"
gem "jbuilder"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "nokogiri", "~> 1.13", ">= 1.13.6"
gem "rails-i18n", "~> 7.0.x"
gem "sassc-rails", "~> 2.0"
gem "sprockets-rails", require: "sprockets/railtie"
gem "terser"

gem "bootstrap-sass", ">= 3.4.1"
gem "bourbon"
# gem "bootstrap-generators", git: "git://github.com/decioferreira/bootstrap-generators.git"
# gem "bootstrap-generators", "~> 3.3.4"

# Authentication
gem "devise"
gem "devise-i18n"
gem "devise_invitable"
gem "omniauth", "~> 2.1.0"
gem "omniauth_openid_connect", "~> 0.7.0"
gem "omniauth-rails_csrf_protection"
gem "simple_token_authentication", "~> 1.0"

gem "datagrid"
gem "faraday"
gem "high_voltage"
gem "kaminari"
gem "pg"
gem "virtus"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use ActiveStorage variant
gem "image_processing", "~> 1.2"

group :development do
  gem "listen", "~> 3.3"
  gem "web-console", ">= 4.1.0"
end
group :development, :test do
  gem "active_record_doctor"
  gem "bullet"
  gem "byebug"
  gem "pry-rails"
  gem "pry-rescue"
  gem "puma"
  gem "rack-mini-profiler"
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rake"

  # gem "formulaic"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "simplecov", require: false
  gem "simplecov-console", require: false
  # gem "sinatra", require: false
  # gem "vcr"
  # gem "webmock"
end

group :test do
  # gem "minitest-rails-capybara"

  gem "capybara", ">= 2.15"
  gem "rspec-html-matchers"
  gem "shoulda-matchers"
end

group :production do
  gem "mini_racer"
  gem "passenger"
  gem "dalli"
end

gem "acts_as_list"
gem "friendly_id", "~> 5.2"
gem "public_activity"
gem "record_tag_helper", "~> 1.0" # Add helpers removed from Rails core in Rails 5
gem "wicked_pdf"
gem "wkhtmltopdf-binary"

# Manage file uploads
gem "shrine", "~> 3.0.x"

# Add email notifications on errors
gem "exception_notification"
gem "letter_opener", group: :development

# Geocode Sites positions
gem "geocoder"

gem "importmap-rails", "~> 1.1"
gem "stimulus-rails", "~> 1.2"
gem "view_component"
gem "debug", group: %i[test development]
