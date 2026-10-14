# frozen_string_literal: true

require "rails_helper"

RSpec.describe NetsightSyncResultsController do
  let(:user) { users(:admin) }
  let(:request_record) { ExternalAppRequest.create!(user:, external_app_name: "netsight", status: :completed) }
  let(:port) { Port.create!(position: 2, attachable: cards(:three), vlans: "u300") }
  let!(:vlan_result) do
    NetsightSyncResult.create!(external_app_request: request_record, server: port.server, port:, kind: :vlan,
                               status: :differs, if_name: "1:7", dcim_value: "u300", netsight_value: "u201")
  end

  before { sign_in user }

  describe "GET #index" do
    subject(:response) do
      get netsight_sync_results_path(params)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { {} }

    it { expect(response).to have_http_status(:success) }
    it { expect(response.body).to include("u201") }
    it { expect(response.body).to include(apply_netsight_sync_results_path(ids: [vlan_result.id])) }

    context "with the links tab" do
      let(:params) { { kind: "link" } }

      it { expect(response.body).not_to include("u201") }
    end

    context "when filtering on another status" do
      let(:params) { { statuses: ["free_text"] } }

      it { expect(response.body).not_to include("u201") }
    end

    context "with a reader" do
      let(:user) { users(:reader) }

      it { expect(response).to redirect_to(root_path) }
    end

    context "when the last attempt failed" do
      before { request_record.fail!("Failed to open TCP connection") }

      it { expect(response.body).to include("Failed to open TCP connection") }
    end

    context "when Netsight is not configured" do
      before { allow(Netsight::Client).to receive(:configured?).and_return(false) }

      it { expect(response.body).not_to include('data-action="external-app-sync#start"') }
    end
  end

  describe "PUT #sync" do
    subject(:response) do
      put sync_netsight_sync_results_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    it { expect { response }.to change(ExternalAppRequest.where(external_app_name: "netsight"), :count).by(1) }
    it { expect { response }.to have_enqueued_job(SyncWithNetsightJob) }

    context "when a synchronization is running" do
      before { request_record.update!(status: :in_progress) }

      it { expect { response }.not_to have_enqueued_job(SyncWithNetsightJob) }
    end

    context "when a synchronization stopped making progress" do
      before do
        request_record.update!(status: :in_progress)
        request_record.update_columns(updated_at: 1.hour.ago) # rubocop:disable Rails/SkipsModelValidations
      end

      it { expect { response }.to have_enqueued_job(SyncWithNetsightJob) }
      it { expect { response }.to change { request_record.reload.status }.to("failed") }
    end

    context "when Netsight is not configured" do
      before { allow(Netsight::Client).to receive(:configured?).and_return(false) }

      it { expect { response }.not_to change(ExternalAppRequest, :count) }
    end
  end

  describe "PATCH #apply" do
    subject(:response) do
      patch apply_netsight_sync_results_path(ids: [vlan_result.id])

      @response # rubocop:disable RSpec/InstanceVariable
    end

    it { expect { response }.to change { port.reload.vlans }.from("u300").to("u201") }
    it { expect(response).to redirect_to(netsight_sync_results_path) }

    context "with a reader" do
      let(:user) { users(:reader) }

      it { expect { response }.not_to(change { port.reload.vlans }) }
    end
  end
end
