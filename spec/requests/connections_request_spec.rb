# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Connections" do
  let(:connection) { connections(:one) }

  describe "GET #edit" do
    subject(:response) do
      get connections_edit_path(from_port_id: connection.port_id)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "POST #update" do
    subject(:response) do
      post connections_update_path, params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { from_port_id: connection.port_id, to_port_id: 5 } }
    let(:invalid_attributes) { { from_port_id: "", to_port_id: "" } }
    let(:params) { { connection: valid_attributes } }

    include_context "with authenticated admin"

    context "with valid parameters" do
      it do
        expect do
          response
          connection.reload
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it do
        expect do
          response
          connection.port.reload
        end.to change(connection.port, :connection)
      end

      it { expect(response).to redirect_to(connections_edit_path(from_port_id: connection.port_id)) }
      it { expect(response).to have_http_status(:redirect) }
    end

    # context "without attributes" do
    #   let(:params) { { connection: {} } }

    #   it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    # end

    # context "without parameters" do
    #   let(:params) { {} }

    #   it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    # end

    context "with invalid parameters" do
      let(:params) { { connection: invalid_attributes } }

      it do
        expect do
          response
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST #update_destination_server" do
    pending "TODO"
  end
end
