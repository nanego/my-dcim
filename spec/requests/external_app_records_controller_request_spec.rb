# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRecordsController do
  let(:ext_app_rec) { external_app_records(:one) }

  before do
    sign_in users(:admin)

    ext_app_rec
  end

  describe "GET #index" do
    subject(:response) do
      get external_app_records_path(params)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { {} }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(ext_app_rec.server.numero) }

    it { expect { response }.to have_rubanok_processed(ExternalAppRecord.all).with(ExternalAppRecordsProcessor) }

    context "when a Netsight synchronization completed after the GLPI one" do
      before do
        ExternalAppRequest.create!(user: users(:admin), external_app_name: "glpi", status: :completed,
                                   updated_at: Time.zone.local(2026, 1, 2, 10, 0))
        ExternalAppRequest.create!(user: users(:admin), external_app_name: "netsight", status: :completed,
                                   updated_at: Time.zone.local(2026, 3, 4, 10, 0))
      end

      it { expect(response.body).to include(I18n.l(Time.zone.local(2026, 1, 2, 10, 0))) }
      it { expect(response.body).not_to include(I18n.l(Time.zone.local(2026, 3, 4, 10, 0))) }
    end

    context "when a Netsight synchronization is running" do
      let!(:netsight_request) do
        ExternalAppRequest.create!(user: users(:admin), external_app_name: "netsight", status: :in_progress)
      end

      it { expect(response.body).not_to include(%(data-external-app-sync-request-id-value="#{netsight_request.id}")) }
    end

    context "when the last attempt failed" do
      before do
        ExternalAppRequest.create!(user: users(:admin), external_app_name: "glpi").fail!("Failed to open TCP connection")
      end

      it { expect(response.body).to include("Failed to open TCP connection") }
    end

    context "when searching on external_serial_status" do
      let(:params) { { external_serial_status: "found" } }

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

    context "when a GLPI synchronization is running" do
      before { ExternalAppRequest.create!(user: users(:admin), external_app_name: "glpi", status: :in_progress) }

      it { expect { response }.not_to have_enqueued_job(SyncWithGlpiJob) }
      it { expect(response.parsed_body).to eq("error" => I18n.t("external_app_records.sync_all_servers_with_glpi.already_running")) }
    end

    context "when only a Netsight synchronization is running" do
      before { ExternalAppRequest.create!(user: users(:admin), external_app_name: "netsight", status: :in_progress) }

      it { expect { response }.to have_enqueued_job(SyncWithGlpiJob) }
    end

    context "when a GLPI synchronization stopped making progress" do
      let!(:stale_request) do
        ExternalAppRequest.create!(user: users(:admin), external_app_name: "glpi", status: :in_progress).tap do |request|
          request.update_columns(updated_at: 1.hour.ago) # rubocop:disable Rails/SkipsModelValidations
        end
      end

      it { expect { response }.to have_enqueued_job(SyncWithGlpiJob) }

      it do
        response
        expect(stale_request.reload).to have_attributes(status: "failed", error_message: be_present)
      end
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

    let(:params) do
      { commit: "true", external_app_record_setting: { category_glpi_sync_types: { categories(:two).id => :server } } }
    end

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(external_app_records_path) }

    it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      expect(categories(:one).glpi_sync_type_server?).to be(true)
      expect(categories(:two).glpi_sync_type_none?).to be(true)

      response
      categories(:one).reload
      categories(:two).reload

      expect(categories(:one).glpi_sync_type_none?).to be(true)
      expect(categories(:two).glpi_sync_type_server?).to be(true)
    end
  end
end
