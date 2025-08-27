# frozen_string_literal: true

if Rails.env.development?
  # require "memory_profiler"
  # require "stackprof"
  require "rack-mini-profiler"

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
  # Rack::MiniProfiler.config.enable_hotwire_turbo_drive_support = true

  Rack::MiniProfilerRails.subscribe("render.view_component") do |_name, start, finish, _id, payload|
    Rack::MiniProfilerRails.render_notification_handler(
      Rack::MiniProfilerRails.shorten_identifier(payload[:identifier]),
      finish,
      start,
    )
  end
end
