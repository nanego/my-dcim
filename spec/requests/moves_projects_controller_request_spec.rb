# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovesProjectsController do
  let(:moves_project) { moves_projects(:one) }

  describe "GET #index" do
    include_context "with authenticated admin"

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

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
  end

  describe "GET #new" do
    subject(:response) do
      get new_moves_project_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post moves_projects_path, params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) do
      {
        name: "A",
        steps_attributes: [
          { name: "1", position: "1" },
          { name: "2", position: "2" },
        ],
      }
    end
    let(:params) { { moves_project: valid_attributes } }
    let(:moves_project) { MovesProject.last }

    include_context "with authenticated admin"

    context "without valid parameters" do
      let(:params) { { moves_project: { name: "" } } }

      it { expect { response }.not_to change(MovesProject, :count) }
      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response).to render_template(:new) }
    end

    context "with valid parameters" do
      it { expect { response }.to change(MovesProject, :count).by(1) }
      it { expect(response).to redirect_to(moves_project_path(assigns(:moves_project))) }

      it "sets current_user as created_by" do
        response

        expect(moves_project.created_by).to eq(user)
      end
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
    subject(:response) do
      get edit_moves_project_path(moves_project)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }

    context "with archived moves project" do
      let(:moves_project) { moves_projects(:archived) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_projects_path) }
    end
  end

  describe "PATCH #update" do
    subject(:response) do
      patch moves_project_path(moves_project), params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { name: "B" } }
    let(:params) { { moves_project: valid_attributes } }

    include_context "with authenticated admin"

    context "without valid parameters" do
      let(:params) { { moves_project: { name: "" } } }

      it do
        expect do
          response
          moves_project.reload
        end.not_to change(moves_project, :name)
      end

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response).to render_template(:edit) }
    end

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

    context "with archived moves project" do
      let(:moves_project) { moves_projects(:archived) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_projects_path) }
    end

    context "with moves project step to destroy" do
      let(:moves_project) { moves_projects(:with_steps) }
      let(:attributes) { { steps_attributes: [{ position: 0, id: moves_project.steps[0].id, _destroy: 1 }] } }
      let(:params) { { moves_project: attributes } }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response).to render_template(:edit) }

      it do
        response
        expect(request.flash[:alert]).not_to be_nil
      end
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete moves_project_path(moves_project, confirm: true)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:moves_project) { moves_projects(:empty) }

    include_context "with authenticated admin"

    it do
      expect do
        response
      end.to change(MovesProject, :count).by(-1)
    end

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(moves_projects_path) }

    context "with archived moves project" do
      let(:moves_project) { moves_projects(:archived) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_projects_path) }
    end

    context "without confirm" do
      subject(:response) do
        delete moves_project_path(moves_project)
        @response # rubocop:disable RSpec/InstanceVariable
      end

      it do
        expect do
          response
        end.not_to change(MovesProject, :count)
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(MovesProject.exists?(moves_project.id)).to be true }
    end
  end

  describe "PATCH #archive" do
    subject(:response) do
      patch archive_moves_project_path(moves_project)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(moves_projects_path) }

    it do
      expect do
        response
        moves_project.reload
      end.to change(moves_project, :archived_at).from(nil)
    end

    context "with archived moves project" do
      let(:moves_project) { moves_projects(:archived) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_projects_path) }
    end
  end
end
