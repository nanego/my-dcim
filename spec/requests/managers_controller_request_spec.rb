# frozen_string_literal: true

require "rails_helper"

RSpec.describe ManagersController do
  describe "GET #index" do
    subject(:response) do
      get managers_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it { expect { response }.to have_rubanok_processed(Manager.all).with(ManagersProcessor) }
  end

  describe "GET #new" do
    subject(:response) do
      get new_manager_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post(managers_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { manager: { name: "Manager 1", description: "Description 1" } } }

    include_context "with authenticated admin"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(manager_path(assigns(:manager))) }
      it { expect { response }.to change(Manager, :count).by(1) }
    end

    context "without attributes" do
      let(:params) { { manager: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end
end
