# frozen_string_literal: true

source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", "~> 8.0.0"

gem "bootstrap", "~> 5.3.2"
gem "dartsass-sprockets"
gem "jbuilder"
gem "nokogiri", "~> 1.18"
gem "rails-i18n", "~> 8.0.x"
gem "sprockets-rails", require: "sprockets/railtie"
gem "terser"

# Authentication
gem "devise"
gem "devise-i18n"
gem "devise_invitable"
gem "omniauth", "~> 2.1.0"
gem "omniauth_openid_connect", "~> 0.7.0"
gem "omniauth-rails_csrf_protection"
gem "simple_token_authentication", github: "gonzalo-bulnes/simple_token_authentication"

gem "datagrid"
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
  gem "dalli"
  gem "mini_racer", "~> 0.16.0"
  gem "passenger"
end

gem "active_storage_validations"
gem "acts_as_list"
gem "friendly_id", "~> 5.2"
gem "record_tag_helper", "~> 1.0" # Add helpers removed from Rails core in Rails 5

# Manage file uploads
gem "shrine", "~> 3.0.x"

# Add email notifications on errors
gem "exception_notification"
gem "letter_opener", group: :development

# Geocode Sites positions
gem "geocoder"

gem "brakeman", group: %i[test development], require: false
gem "csv"
gem "debug", group: %i[test development], platforms: %i[mri windows], require: "debug/prelude"
gem "dekorator", "~> 1.4"
gem "diffy", "~> 3.4"
gem "hotwire-livereload", group: :development
gem "importmap-rails", "~> 2.0"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "requestjs-rails"
gem "rubanok"
gem "scenic"
gem "stimulus-rails", "~> 1.2"
gem "store_attribute", "~> 1.2"
gem "turbo-rails"
gem "view_component"
