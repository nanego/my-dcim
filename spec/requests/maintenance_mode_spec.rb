# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Maintenance mode" do
  # Signed in, so that the same request would load the user from the database
  # if the middleware let it through.
  before { sign_in(users(:admin)) }

  def sql_queries_while
    queries = []
    subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*, payload|
      queries << payload[:sql] unless payload[:name] == "SCHEMA"
    end
    yield
    queries
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber)
  end

  context "without the flag file" do
    it "serves the application" do
      get root_url

      expect(response).to have_http_status(:success)
    end
  end

  context "with the flag file" do
    around do |example|
      FileUtils.touch(MaintenanceModeMiddleware::FLAG_PATH)
      example.run
    ensure
      FileUtils.rm_f(MaintenanceModeMiddleware::FLAG_PATH)
    end

    describe "the response" do
      subject(:response) do
        get root_url
        @response # rubocop:disable RSpec/InstanceVariable
      end

      it { expect(response).to have_http_status(:service_unavailable) }
      it { expect(response.body).to include("My DCIM est en maintenance") }
      it { expect(response.headers["retry-after"]).to eq(MaintenanceModeMiddleware::RETRY_AFTER.to_s) }
      it { expect(response.headers["cache-control"]).to eq("no-store") }
    end

    it "answers non GET requests too" do
      post user_session_url, params: { user: { email: "a@b.c", password: "secret" } }

      expect(response).to have_http_status(:service_unavailable)
    end

    it "sends no query to the database" do
      queries = sql_queries_while { get root_url }

      expect(queries).to be_empty
    end
  end
end
