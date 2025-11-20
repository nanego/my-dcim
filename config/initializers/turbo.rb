# frozen_string_literal: true

if Rails.env.development?
  Rails.application.configure do
    # See: https://github.com/hotwired/spark?tab=readme-ov-file#configuration
    # config.hotwire.spark.html_extensions += %w[ruby]
    config.hotwire.spark.html_paths += %w[app/components app/decorators]
    config.hotwire.spark.css_extensions += %w[scss]
  end
end
