# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/power_distribution_units" do
  let(:pdu) { servers(:pdu) }
  let(:pdu2) { Server.create(name: "PDU 2", frame_id: 2, modele_id: 3, numero: "PDU_2") }
  let(:server) { servers(:one) }

  before do
    sign_in users(:admin)

    pdu.save
    server.save
    pdu2
  end

  describe "GET /index" do
    before { get power_distribution_units_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(pdu.name) }
    it { expect(response.body).to include(pdu2.name) }
    it { expect(response.body).not_to include(server.name) }

    context "when searching on name" do
      before { get power_distribution_units_path(q: "PDU_FRAME") }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }
      it { expect(response.body).to include(pdu.name) }
      it { expect(response.body).not_to include(pdu2.name) }
      it { expect(response.body).not_to include(server.name) }
    end
  end

  describe "GET /show" do
    before { get power_distribution_unit_path(pdu) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
    it { expect(response.body).to include(pdu.name) }

    context "when using id" do
      before { get power_distribution_unit_path(pdu.id) }

      it { expect(response).to have_http_status(:success) }
    end

    context "when using name" do
      before { get power_distribution_unit_path(pdu.name) }

      it { expect(response).to render_template(:show) }
    end

    context "when using serial number" do
      before { get power_distribution_unit_path(pdu.numero) }

      it { expect(response).to render_template(:show) }
    end

    context "with an id not set" do
      it { expect { get power_distribution_unit_path("unknown-id") }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "GET /new" do
    before { get new_power_distribution_unit_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "GET /duplicate" do
    before { get duplicate_power_distribution_unit_path(pdu) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:duplicate) }
  end

  describe "POST /create" do
    subject(:response) do
      post(power_distribution_units_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) do
      { power_distribution_unit: pdu.attributes.except(%w[id numero name]).merge(numero: "new_numero", name: "NewServerName") }
    end

    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect { response }.to change(Server, :count).by(1) }
      it { expect(response).to redirect_to(power_distribution_unit_path(assigns(:pdu))) }
    end

    context "with no attributes" do
      let(:params) { { power_distribution_unit: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with no parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid parameters" do
      let(:params) { { power_distribution_unit: { name: "" } } }

      it { expect(response).to render_template(:new) }
    end
  end

  describe "GET /edit" do
    before { get edit_power_distribution_unit_path(pdu) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { pdu.attributes.except("name").merge(name: "New name") }

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        patch power_distribution_unit_path(pdu), params: { power_distribution_unit: new_attributes }
        pdu.reload
        assigns(:pdu).reload

        expect(response).to be_redirection
        expect(response).to redirect_to(power_distribution_unit_path(assigns(:pdu)))
        expect(pdu.name).to eq(new_attributes[:name])

        # old name should continue to work
        get power_distribution_unit_path("PDU_FRAME-1_A")
        expect(response).to have_http_status(:success)
        expect(pdu).to eq(assigns(:pdu))
      end

      it "does update cards in a server", :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        patch power_distribution_unit_path(pdu), params: {
          power_distribution_unit: {
            name: pdu.name,
            cards_attributes: [{ id: 7, composant_id: 1, twin_card_id: 2, orientation: "lr-td" }],
          },
        }

        assigns(:pdu).reload
        pdu.reload

        expect(response).to be_redirection
        expect(response).to redirect_to(power_distribution_unit_path(assigns(:pdu)))

        # Test new card
        get power_distribution_unit_path(pdu)
        expect(response).to have_http_status(:success)
        expect(pdu).to eq(assigns(:pdu))
        expect(Card.find(7).twin_card_id).to eq 2

        # Test twin card
        expect(Card.find(2).twin_card_id).to eq 7
      end
    end

    context "with invalid parameters" do
      it "does not update a PDU without attributes" do
        expect { patch power_distribution_unit_path(pdu), params: { power_distribution_unit: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a PDU without parameters" do
        expect { patch power_distribution_unit_path(pdu), params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a PDU with invalid parameters", :aggregate_failures do
        patch power_distribution_unit_path(pdu), params: { power_distribution_unit: { name: "" } }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /destroy" do
    context "with a pdu without association" do
      it "destroys the requested pdu" do
        expect do
          delete power_distribution_unit_path(pdu2)
        end.to change(Server, :count).by(-1)
      end

      it "redirects to the pdus list" do
        delete power_distribution_unit_path(pdu2)
        expect(response).to redirect_to(power_distribution_units_path)
      end

      it "redirects to the pdus list and keep params" do
        delete power_distribution_unit_path(pdu2, params: { sort: "asc", sort_by: "rooms.name" })
        expect(response).to redirect_to(power_distribution_units_path({ sort: "asc", sort_by: "rooms.name" }))
      end
    end

    context "with a pdu with association" do
      it "does not destroy the requested pdu" do
        expect do
          delete power_distribution_unit_path(pdu)
        end.not_to change(Server, :count)
      end

      it "redirects to the pdus list" do
        delete power_distribution_unit_path(pdu)
        expect(response).to redirect_to(power_distribution_units_path)
      end
    end
  end

  describe "GET /destroy_connections" do
    before { get destroy_connections_power_distribution_unit_path(pdu) }

    it { expect(response).to have_http_status(:redirect) }
    it { expect(pdu.connections.count).to be_zero }
    it { expect(flash[:notice]).to be_present }
  end
end
