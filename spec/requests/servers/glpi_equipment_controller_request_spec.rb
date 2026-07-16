# frozen_string_literal: true

require "rails_helper"

RSpec.describe Servers::GlpiEquipmentController do
  let(:server) { servers(:one) }

  describe "GET #show" do
    subject(:response) do
      get server_glpi_equipment_path(server)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    context "with regular server present in GLPI" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
      it { expect(response.body).to include("argoli") }
    end

    context "with glpi_sync_type none" do
      let(:server) { servers(:hub_network1) }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include("bi-slash-circle") }
    end

    context "when exception raised" do
      before do
        allow(GlpiClient).to receive(:new).and_raise(StandardError.new("custom error"))
        response
      end

      it { expect(assigns(:connection_error)).to eq("custom error") }
    end
  end
end
