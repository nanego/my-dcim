# frozen_string_literal: true

require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  options = {
    window_size: [1920, 1080],
    inspector: false,
    js_errors: true,
    timeout: 10
  }

  options[:headless] = true

  Capybara::Cuprite::Driver.new(app, options)
end

# NOTE: Wait for AJAX response since turbo make SHR requests.
Capybara.default_max_wait_time = 5
Capybara.javascript_driver = :cuprite
Capybara.server = :puma, { Silent: true }
