# frozen_string_literal: true

if Rails.env.development?
  Rails.application.configure do
    config.hotwire.spark.html_paths += %w[app/components]
  end
end
