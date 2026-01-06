# frozen_string_literal: true

require "rails_helper"

RSpec.describe ManufacturersController do
  let(:manufacturer) { Manufacturer.create! }
  let(:modele) { Modele.create!(manufacturer:, category: Category.create!, architecture: Architecture.create!) }
  let(:server) { Server.create!(name: "A", numero: "numeroA", frame: frames(:one), modele:) }

  describe "GET #new" do
    subject(:response) do
      get new_manufacturer_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post(manufacturers_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { manufacturer: { name: "Manufacturer 1", description: "Description 1" } } }

    include_context "with authenticated admin"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(manufacturer_path(assigns(:manufacturer))) }
      it { expect { response }.to change(Manufacturer, :count).by(1) }
    end

    context "without attributes" do
      let(:params) { { manufacturer: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "GET #index" do
    subject(:response) do
      get manufacturers_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    before { server }

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(I18n.t("activerecord.attributes.manufacturer.servers_count", count: 1)) }
  end
end
