# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArchitecturesController do
  let(:architecture) { architectures(:three) }

  describe "GET #index" do
    subject(:response) do
      get architectures_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it { expect { response }.to have_rubanok_processed(Architecture.all).with(ArchitecturesProcessor) }
  end

  describe "GET #show" do
    subject(:response) do
      get architecture_path(architecture)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
  end

  describe "GET #new" do
    subject(:response) do
      get new_architecture_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post(architectures_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { architecture: { name: "Arhitecture 1", description: "Description 1" } } }

    include_context "with authenticated admin"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(architecture_path(assigns(:architecture))) }
      it { expect { response }.to change(Architecture, :count).by(1) }
    end

    context "without attributes" do
      let(:params) { { architecture: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_architecture_path(architecture)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch(architecture_url(architecture), params:)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:manufacturer) { manufacturers(:juniper) }
    let(:params) { { air_conditioner_model: { name: "New name", manufacturer_id: manufacturer.id } } }

    include_context "with authenticated admin"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(air_conditioner_model_url(air_conditioner_model)) }

      it do
        expect do
          response
          air_conditioner_model.reload
        end.to change(air_conditioner_model, :name).to("New name")
      end
    end

    context "with invalid parameters" do
      let(:params) { { air_conditioner_model: { name: "new name", manufacturer_id: -1 } } }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response).to render_template(:edit) }

      it do
        expect do
          response
          air_conditioner_model.reload
        end.not_to change(air_conditioner_model, :name)
      end
    end
  end
end
