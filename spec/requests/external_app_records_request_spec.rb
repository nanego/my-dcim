# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ExternalAppRecords" do
  let(:ext_app_rec) { external_app_records(:one) }

  before do
    sign_in users(:one)

    ext_app_rec
  end

  describe "GET #index" do
    subject(:response) do
      get external_app_records_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(ext_app_rec.server.numero) }
  end

  describe "PUT #sync_all_servers_with_glpi" do
    it "creates a new request and enqueues the job" do
      expect {
        put sync_with_glpi_external_app_records_path
      }.to change(ExternalAppRequest, :count).by(1)

      expect(SyncWithGlpiJob).to have_been_enqueued

      request = ExternalAppRequest.last
      json_response = JSON.parse(response.body)
      expect(json_response).to include("request_id" => request.id,
                                       "status" => "pending",
                                       "progress" => 0)
    end
  end
end
