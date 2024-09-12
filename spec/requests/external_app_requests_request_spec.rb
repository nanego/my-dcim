# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ExternalAppRequests" do
  let(:request) { external_app_requests(:one) }

  before do
    sign_in users(:one)

    request
  end

  describe "GET #show" do
    subject(:response) do
      get external_app_request_path(request)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    it "returns the request status and progress" do
      json_response = JSON.parse(response.body)
      expect(json_response).to include("status" => request.status,
                                       "progress" => request.progress)
    end
  end
end
