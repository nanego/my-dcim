# frozen_string_literal: true

require "view_component/test_helpers"

RSpec.configure do |config|
  config.include RSpecHtmlMatchers, type: :component

  config.include ViewComponent::TestHelpers, type: :component

  config.include Capybara::RSpecMatchers, type: :component
end
