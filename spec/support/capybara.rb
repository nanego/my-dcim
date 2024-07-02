# frozen_string_literal: true

require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  options = {
    window_size: [1920, 1080],
    inspector: false,
    js_errors: true
  }

  options[:headless] = true
  options[:browser_options][:'no-sandbox'] = nil if ENV["CI"]

  Capybara::Cuprite::Driver.new(app, options)
end

# NOTE: Wait for AJAX response since turbo make SHR requests.
Capybara.default_max_wait_time = 10
Capybara.javascript_driver = :cuprite
Capybara.server = :puma, { Silent: true }
