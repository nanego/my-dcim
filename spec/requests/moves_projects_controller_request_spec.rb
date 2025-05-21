# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovesProjectsController do
  let(:moves_project) { moves_projects(:one) }

  describe "GET #index" do
    include_context "with authenticated user"

    before { get moves_projects_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
  end

  describe "GET #show" do
    subject(:response) do
      get moves_project_path(moves_project)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
  end

  describe "GET #new" do
    subject(:response) do
      get new_moves_project_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post moves_projects_path, params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { name: "A" } }
    let(:params) { { moves_project: valid_attributes } }

    include_context "with authenticated user"

    context "with valid parameters" do
      it { expect { response }.to change(MovesProject, :count).by(1) }
      it { expect(response).to redirect_to(moves_project_path(assigns(:moves_project))) }
    end

    context "without attributes" do
      let(:params) { { moves_project: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "GET #edit" do
    include_context "with authenticated user"

    before { get edit_moves_project_path(moves_project) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch moves_project_path(moves_project), params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { name: "B" } }
    let(:params) { { moves_project: valid_attributes } }

    include_context "with authenticated user"

    context "with valid parameters" do
      it do
        expect do
          response
          moves_project.reload
        end.to change(moves_project, :name).to("B")
      end

      it { expect(response).to redirect_to(moves_project_path(moves_project)) }
      it { expect(response).to have_http_status(:redirect) }
    end

    context "without attributes" do
      let(:params) { { moves_project: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete moves_project_path(moves_project)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it do
      expect do
        response
      end.to change(MovesProject, :count).by(-1)
    end

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(moves_projects_path) }
  end
end
