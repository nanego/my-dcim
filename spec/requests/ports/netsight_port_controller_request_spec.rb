# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ports::NetsightPortController do
  let(:port) { ports(:four) }

  describe "GET #show" do
    subject(:response) do
      get port_netsight_port_path(port)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    context "with a port on a switch known to Netsight" do
      before { servers(:one).update!(name: "SW_TEST01:Slot2") }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
      it { expect(response.body).to include("STORAGE-1 CTRL") }
      it { expect(response.body).to include("t1192, t1194") }
      it { expect(response.body).to include("netsight-vlans#apply") }

      it "asks Netsight for the switch port" do
        client = Netsight::Client.new
        allow(Netsight::Client).to receive(:new).and_return(client)
        allow(client).to receive(:port).and_call_original

        response

        expect(client).to have_received(:port).with(ip: "192.0.2.63", if_index: 2011)
      end
    end

    context "when the VLANs already match DCIM" do
      before do
        servers(:one).update!(name: "SW_TEST01:Slot2")
        port.update!(vlans: "t1194, t1192")
      end

      it { expect(response.body).not_to include("netsight-vlans#apply") }
    end

    context "without any switch around the port" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response.body).to include(I18n.t("ports.netsight_port.show.no_switch")) }
    end

    context "when Netsight is not configured" do
      before { allow(Netsight::Client).to receive(:configured?).and_return(false) }

      it { expect(response.body).to include(I18n.t("ports.netsight_port.show.not_configured")) }
    end

    context "when exception raised" do
      before do
        allow(Netsight::Client).to receive(:new).and_raise(StandardError.new("custom error"))
        response
      end

      it { expect(assigns(:connection_error)).to eq("custom error") }
    end
  end
end
