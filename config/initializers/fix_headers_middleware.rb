# frozen_string_literal: true

require 'rack/utils'

class FixHeadersMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["HTTP_X_FORWARDED_HOST"]
      env["HTTP_X_FORWARDED_HOST"].gsub!(/,\s?[^,]+.ac.cs$/,"")
    end
    @app.call(env)
  end
end

Rails.application.config.middleware.use FixHeadersMiddleware
