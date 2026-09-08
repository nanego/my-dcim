# frozen_string_literal: true

require "rack/utils"

class FixHeadersMiddleware
  def initialize(app)
    @app = app
  end

  # Reverse proxies append their backend host to X-Forwarded-Host, and Rails
  # resolves the request host from the last value of that header. Keep only the
  # first one.
  def call(env)
    forwarded_host = env["HTTP_X_FORWARDED_HOST"]
    env["HTTP_X_FORWARDED_HOST"] = forwarded_host.split(/,\s*/).first if forwarded_host.present?

    @app.call(env)
  end
end

Rails.application.config.middleware.use FixHeadersMiddleware
