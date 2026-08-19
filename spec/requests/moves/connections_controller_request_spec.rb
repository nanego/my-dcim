# frozen_string_literal: true

require "rails_helper"

RSpec.describe Moves::ConnectionsController do
  let(:move) { moves(:one) }
  let(:move_connection) { move_connections(:one) }

  describe "GET #index" do
    subject(:response) do
      get move_connections_path(move)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
  end

  describe "GET #new" do
    subject(:response) do
      get new_move_connection_path(move, params: { port_from_id: ports(:one).id })

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_move_connection_path(move, move_connection)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "POST #create" do
    subject(:response) do
      post(move_connections_path(move), params:)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { move_connection: { cable_name: "", cable_color: "", vlans: "", port_from_id: 7, port_to_id: 10 } } }

    include_context "with authenticated admin"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect { response }.to change(Move::Connection, :count).by(1) }
      it { expect(response).to redirect_to(move_connections_path(move)) }
    end

    context "with no attributes" do
      let(:params) { { move_connection: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with no parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid parameters" do
      let(:params) { { move_connection: { cable_name: "" } } }

      it { expect { response }.not_to change(Move::Connection, :count) }
      it { expect(response).to render_template(:new) }
    end
  end

  describe "PATCH #update" do
    subject(:response) do
      patch(move_connection_path(move, move_connection), params:)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:attributes) { { cable_name: "new name" } }
    let(:params) { { move_connection: attributes } }

    include_context "with authenticated admin"

    context "with valid parameters" do
      it do
        expect do
          response
          move_connection.reload
        end.to change(move_connection, :cable_name).to("new name")
      end

      it { expect(response).to redirect_to(move_connections_path(move)) }
      it { expect(response).to have_http_status(:redirect) }
    end

    context "without attributes" do
      let(:attributes) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid attributes" do
      let(:attributes) { { port_from_id: "" } }

      it { expect(response).to render_template(:edit) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete move_connection_path(move, move_connection, **params)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { confirm: true } }

    include_context "with authenticated admin"

    context "without confirm" do
      let(:params) { {} }

      it { expect { response }.not_to change(Move::Connection, :count) }
      it { expect(response).to have_http_status(:success) }
      it { expect(Move::Connection.exists?(move_connection.id)).to be(true) }
    end

    context "with confirm" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect { response }.to change(Move::Connection, :count).by(-1) }
      it { expect(response).to redirect_to(move_connections_path(move)) }
    end

    context "with custom back_to" do
      let(:params) { { confirm: true, back_to: "/some_path" } }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to("/some_path") }
      it { expect { response }.to change(Move::Connection, :count).by(-1) }
    end
  end
end
