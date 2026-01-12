# frozen_string_literal: true

source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", "~> 8.0.0"

gem "bootstrap", "~> 5.3.2"
gem "dartsass-sprockets", "~> 3.2"
gem "jbuilder"
gem "nokogiri", "~> 1.18"
gem "rails-i18n", "~> 8.1"
gem "sprockets-rails", require: "sprockets/railtie"
gem "terser"

# Authentication
gem "devise", "~> 4.9"
gem "devise-i18n"
gem "devise_invitable"
gem "omniauth", "~> 2.1.0"
gem "omniauth_openid_connect", "~> 0.7.0"
gem "omniauth-rails_csrf_protection"
gem "simple_token_authentication", github: "gonzalo-bulnes/simple_token_authentication"

gem "datagrid", "~> 1.x"
gem "dry-struct"
gem "faraday"
gem "kaminari" # TODO: Remove when removing datagrid
gem "pagy"
gem "pg"

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
  gem "byebug"
  gem "lookbook"
  gem "puma"
  gem "rack-mini-profiler", require: false
  gem "rubocop", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
end

group :test do
  gem "capybara", ">= 2.15"
  gem "cuprite"
  gem "formulaic"
  gem "minitest", "~> 5.x"
  gem "rails-controller-testing"
  gem "rspec-activemodel-mocks"
  gem "rspec-html-matchers"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "simplecov-console", require: false
  # gem "minitest-rails-capybara"
  # gem "sinatra", require: false
  # gem "vcr"
  # gem "webmock"
end

group :production do
  gem "connection_pool", "~> 2.4.1" # Force compatible version, v3.0 is NOT currently compatible with Rails 8
  gem "dalli", "~> 3.2"
  gem "mini_racer", "~> 0.16.0"
  gem "passenger", "~> 6.0"
end

gem "active_storage_validations", "~> 3.0"
gem "acts_as_list", "~> 1.2"
gem "friendly_id", "~> 5.2"
gem "record_tag_helper", "~> 1.0" # Add helpers removed from Rails core in Rails 5

# Manage file uploads
gem "shrine", "~> 3.0.x"

# Add email notifications on errors
gem "exception_notification"
gem "letter_opener", group: :development

# Geocode Sites positions
gem "geocoder", "~> 1.8"

gem "action_policy", "~> 0.7"
gem "brakeman", group: %i[test development], require: false
gem "csv", "~> 3.3"
gem "debug", group: %i[test development], platforms: %i[mri windows], require: "debug/prelude"
gem "dekorator", "~> 1.4"
gem "diffy", "~> 3.4"
gem "hotwire-spark", group: :development
gem "importmap-rails", "~> 2.0"
gem "jquery-rails", "~> 4.6"
gem "jquery-ui-rails", "~> 8.0"
gem "requestjs-rails", "~> 0.0.12"
gem "rubanok", "~> 0.5"
gem "scenic", "~> 1.8"
gem "stimulus-rails", "~> 1.2"
gem "store_attribute", "~> 1.2"
gem "turbo-rails", "~> 2.0"
gem "view_component", "~> 3.21"
