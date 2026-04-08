# frozen_string_literal: true

FerrumPdf.configure do |config|
  config.timeout = 30

  config.pdf_options.scale = 0.6
end
