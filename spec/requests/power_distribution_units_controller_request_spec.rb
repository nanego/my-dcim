# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitsController do
  let(:power_distribution_unit) { power_distribution_units(:one) }

  describe "GET #index" do
    subject(:response) do
      get power_distribution_units_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(power_distribution_unit.name) }

    it { expect { response }.to have_rubanok_processed(PowerDistributionUnit.all).with(PowerDistributionUnitsProcessor) }

    it do
      response
      expect(assigns(:filter)).to be_present
    end
  end

  describe "GET #show" do
    subject(:response) do
      get power_distribution_unit_path(power_distribution_unit)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    context "with not found power distribution unit" do
      let(:power_distribution_unit) { PowerDistributionUnit.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing power distribution unit" do
      before { response }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
    end
  end

  describe "GET #new" do
    subject(:response) do
      get new_power_distribution_unit_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_power_distribution_unit_path(power_distribution_unit)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "POST #create" do
    subject(:response) do
      post(power_distribution_units_path, params:)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) do
      {
        power_distribution_unit: power_distribution_unit.attributes.except(%w[id name serial_number])
          .merge(name: "PDU Name",
                 serial_number: "321",
                 circuits_attributes: [
                   { name: "c1" },
                   { name: "c2", sockets_attributes: [{ name: "s1", port_type_id: 1 }] },
                 ]),
      }
    end

    include_context "with authenticated admin"

    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect { response }.to change(PowerDistributionUnit, :count).by(1) }
      it { expect(response).to redirect_to(power_distribution_unit_path(assigns(:power_distribution_unit))) }
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

      it { expect { response }.not_to change(PowerDistributionUnit, :count) }
      it { expect(response).to render_template(:new) }
    end
  end

  describe "PATCH #update" do
    subject(:response) do
      patch(power_distribution_unit_path(power_distribution_unit), params:)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:attributes) do
      {
        bay_id: "2",
        circuits_attributes: [
          { name: "c1" },
          { name: "c2", sockets_attributes: [{ name: "s1", port_type_id: 1 }] },
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
        end.to change(power_distribution_unit, :bay_id).to(2)
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
      let(:attributes) { { bay_id: "" } }

      it { expect(response).to render_template(:edit) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete power_distribution_unit_path(power_distribution_unit, **params)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { confirm: true } }

    include_context "with authenticated admin"

    context "without confirm" do
      let(:params) { {} }

      it { expect { response }.not_to change(PowerDistributionUnit, :count) }
      it { expect(response).to have_http_status(:success) }
      it { expect(PowerDistributionUnit.exists?(power_distribution_unit.id)).to be(true) }
    end

    context "with confirm" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect { response }.to change(PowerDistributionUnit, :count).by(-1) }
      it { expect(response).to redirect_to(power_distribution_units_path) }
    end

    context "with custom back_to" do
      let(:params) { { confirm: true, back_to: "/some_path" } }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to("/some_path") }
      it { expect { response }.to change(PowerDistributionUnit, :count).by(-1) }
    end
  end

  describe "GET #duplicate" do
    subject(:response) do
      get duplicate_power_distribution_unit_path(power_distribution_unit)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:duplicate) }
  end
end
