# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ExternalAppRecords" do
  let(:ext_app_rec) { external_app_records(:one) }

  before do
    sign_in users(:one)

    ext_app_rec
  end

  describe "GET #index" do
    before { get external_app_records_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(ext_app_rec.server.numero) }

    context "when searching on external_serial_status" do
      before { get external_app_records_path(external_serial_status: "found") }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }
      it { expect(response.body).to include(external_app_records(:two).server.name) }
      it { expect(response.body).not_to include(ext_app_rec.server.name) }
    end
  end

  describe "PUT #sync_all_servers_with_glpi" do
    subject(:response) do
      put sync_with_glpi_external_app_records_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    it "creates a new request and enqueues the job" do
      expect do
        response
      end.to change(ExternalAppRequest, :count).by(1)
    end

    it "enqueues the job" do
      expect do
        response
      end.to have_enqueued_job(SyncWithGlpiJob)
    end

    it do
      expect(response.parsed_body).to include("request_id" => ExternalAppRequest.last.id,
                                              "status" => "pending",
                                              "progress" => 0)
    end
  end

  describe "GET #settings" do
    before { get settings_external_app_records_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:settings) }
  end

  describe "PUT #settings" do
    subject(:response) do
      put settings_external_app_records_path, params: params

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { commit: "true", external_app_record_setting: { category_ids: [categories(:two).id] } } }

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(external_app_records_path) }

    it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      expect(categories(:one).is_glpi_synchronizable).to be(true)
      expect(categories(:two).is_glpi_synchronizable).to be(false)

      response
      categories(:one).reload
      categories(:two).reload

      expect(categories(:one).is_glpi_synchronizable).to be(false)
      expect(categories(:two).is_glpi_synchronizable).to be(true)
    end
  end
end
