# frozen_string_literal: true

require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  options = {
    window_size: [1920, 1080],
    browser_options: {},
    inspector: ENV.fetch("CUPRITE_INSPECTOR", nil),
    js_errors: true,
  }

  options[:headless] = ENV.fetch("CUPRITE_HEADLESS", nil) != "false"
  options[:browser_options][:"no-sandbox"] = nil if ENV["CI"]

  Capybara::Cuprite::Driver.new(app, options)
end

# NOTE: Wait for AJAX response since turbo make SHR requests.
Capybara.default_max_wait_time = 5
Capybara.javascript_driver = :cuprite
Capybara.server = :puma, { Silent: true }
