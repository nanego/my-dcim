# frozen_string_literal: true

RSpec.configure do |config|
  config.include Formulaic::Dsl, type: :feature
end

# NOTE: Wait for AJAX response since turbo make SHR requests.
# See: https://github.com/thoughtbot/formulaic/blob/6f80b41773aa17f73847598abbd1e2b220b09715/README.md#assumptions
Formulaic.default_wait_time = 5
