# frozen_string_literal: true

# Serves a static maintenance page as long as tmp/maintenance.txt exists on the
# server. Removing the file lifts the maintenance, no restart needed.
#
# The middleware sits at the very top of the stack, so a request handled here
# never reaches ActiveRecord: no query is sent to PostgreSQL, which is what
# makes a database dump or restore safe while the application is running.
class MaintenanceModeMiddleware
  FLAG_PATH = Rails.root.join("tmp/maintenance.txt")
  PAGE_PATH = Rails.public_path.join("maintenance.html")
  RETRY_AFTER = 300

  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env) unless File.exist?(FLAG_PATH)

    page = File.binread(PAGE_PATH)
    [503, headers(page), [page]]
  end

  private

  def headers(page)
    {
      "content-type" => "text/html; charset=utf-8",
      "content-length" => page.bytesize.to_s,
      # Without this, browsers keep displaying the page once maintenance is over.
      "cache-control" => "no-store",
      "retry-after" => RETRY_AFTER.to_s,
    }
  end
end

Rails.application.config.middleware.insert_before 0, MaintenanceModeMiddleware
