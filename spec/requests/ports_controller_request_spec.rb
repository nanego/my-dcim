# frozen_string_literal: true

require "rails_helper"

RSpec.describe PortsController do
  let(:port) { ports(:one) }

  describe "GET #edit" do
    subject(:response) do
      get edit_port_path(port, **params)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { {} }

    include_context "with authenticated admin"

    context "with given port" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(connections_edit_path(from_port_id: port)) }
    end

    context "with new port" do
      let(:port)   { 0 }
      let(:params) { { card_id: cards(:one) } }

      it { expect { response }.to change(Port, :count).by(1) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(connections_edit_path(from_port_id: assigns(:port))) }
    end

    context "with new port from socket" do
      let(:port)   { 0 }
      let(:params) { { socket_id: power_distribution_unit_sockets(:one) } }

      it { expect { response }.to change(Port, :count).by(1) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(connections_edit_path(from_port_id: assigns(:port))) }
    end
  end
end
