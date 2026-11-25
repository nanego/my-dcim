# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnits::BlocksController do
  let(:power_distribution_unit) { power_distribution_units(:one) }

  describe "GET #edit" do
    subject(:response) do
      get edit_power_distribution_unit_blocks_path(power_distribution_unit)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch(power_distribution_unit_blocks_path(power_distribution_unit), params:)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:attributes) do
      {
        blocks_attributes: [
          { position: 3, sockets_attributes: [{ position: 999, name: "some", port_type_id: 1, circuit_id: 1 }] },
          { position: 4 },
        ],
        cards_attributes: [
          { name: "card1", card_type_id: 1, first_position: 1, orientation: "lr-td" },
        ],
      }
    end
    let(:params) { { power_distribution_unit: attributes } }

    include_context "with authenticated admin"

    context "with valid parameters" do
      it do
        expect do
          response
          power_distribution_unit.reload
        end.to change(power_distribution_unit.blocks, :count).to(3)
      end

      it { expect(response).to redirect_to(power_distribution_unit_path(assigns(:power_distribution_unit))) }
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
      let(:attributes) { { cards_attributes: [{ name: "" }] } }

      it { expect(response).to render_template(:edit) }
    end
  end
end
