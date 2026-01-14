# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovesController do
  let(:move) { moves(:planned) }
  let(:step) { move.step }
  let(:server) { servers(:one) }

  describe "GET #index" do
    include_context "with authenticated writer"

    before { get moves_project_step_moves_path(step) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
  end

  describe "GET #show" do
    subject(:response) do
      get moves_project_step_move_path(step, move)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated writer"

    # TODO: test that JSON call is working fine
    # context "with format = json" do
    #   before { get move_path(move, format: :json) }

    #   it { expect(response).to have_http_status(:success) }
    #   it { expect(response).to render_template(:show) }
    # end

    context "with format = html" do
      it { expect { response }.to raise_error(ActionController::UnknownFormat) }
    end
  end

  describe "GET #new" do
    subject(:response) do
      get new_moves_project_step_move_path(step)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }

    context "with a params[:server_id] passed" do
      subject(:response) do
        get new_moves_project_step_move_path(step, server_id: server.id)

        # NOTE: used to simplify usage and custom test done in final spec file.
        @response # rubocop:disable RSpec/InstanceVariable
      end

      before { response }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:new) }

      it { expect(server).to eq(assigns(:move).moveable) }
    end

    context "with a params[:server_id] passed and not scoped by a moves project" do
      subject(:response) do
        get new_move_path(server_id: server.id)

        # NOTE: used to simplify usage and custom test done in final spec file.
        @response # rubocop:disable RSpec/InstanceVariable
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:new_unscoped) }
    end

    context "with an archived moves project" do
      let(:move) { moves(:archived) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_projects_path) }
    end
  end

  describe "POST #create" do
    subject(:response) do
      post moves_project_step_moves_path(step), params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) do
      {
        moveable_type: "Server",
        moveable_id: servers(:four).id,
        frame_id: frames(:two).id,
        position: 40,
      }
    end
    let(:params) { { move: valid_attributes } }

    include_context "with authenticated admin"

    context "with valid parameters" do
      it { expect { response }.to change(Move, :count).by(1) }
      it { expect(response).to redirect_to(moves_project_path(step)) }
    end

    context "without attributes" do
      let(:params) { { move: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with an archived moves project" do
      let(:move) { moves(:archived) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_projects_path) }
    end

    context "with a params[:unscoped] passed" do
      subject(:response) do
        post moves_project_step_moves_path(step), params: params

        # NOTE: used to simplify usage and custom test done in final spec file.
        @response # rubocop:disable RSpec/InstanceVariable
      end

      let(:params) { { move: { moveable_id: servers(:two).id, moveable_type: "Server", moves_project_step_id: step.id }, unscoped: "Continue" } }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(new_moves_project_step_move_path(step, server_id: servers(:two).to_param)) }
    end

    context "with a params[:unscoped] passed and invalid params" do
      subject(:response) do
        post moves_project_step_moves_path(step), params: params

        # NOTE: used to simplify usage and custom test done in final spec file.
        @response # rubocop:disable RSpec/InstanceVariable
      end

      let(:params) { { move: { moveable_id: servers(:two).id, moveable_type: "Server", moves_project_step_id: nil }, unscoped: "Continue" } }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response).to render_template(:new_unscoped) }
    end
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_moves_project_step_move_path(step, move)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }

    context "with an archived moves project" do
      let(:move) { moves(:archived) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_projects_path) }
    end
  end

  describe "PATCH #update" do
    subject(:response) do
      patch moves_project_step_move_path(step, move), params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { position: 8 } }
    let(:params) { { move: valid_attributes } }

    include_context "with authenticated admin"

    context "with valid parameters" do
      it do
        expect do
          response
          move.reload
        end.to change(move, :position).to(8)
      end

      it { expect(response).to redirect_to(moves_project_path(step)) }
      it { expect(response).to have_http_status(:redirect) }
    end

    context "without attributes" do
      let(:params) { { move: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with an archived moves project" do
      let(:move) { moves(:archived) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_projects_path) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete moves_project_step_move_path(step, move, confirm: true)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it do
      expect do
        response
      end.to change(Move, :count).by(-1)
    end

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(moves_project_path(step)) }

    context "when executed" do
      let(:move) { moves(:executed) }

      it do
        expect do
          response
        end.not_to change(Move, :count)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_project_path(step)) }
    end

    context "with an archived moves project" do
      let(:move) { moves(:archived) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_projects_path) }
    end

    context "without confirm" do
      subject(:response) do
        delete moves_project_step_move_path(step, move)
        @response # rubocop:disable RSpec/InstanceVariable
      end

      it do
        expect do
          response
        end.not_to change(Move, :count)
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(Move.exists?(move.id)).to be true }
    end
  end

  describe "GET #execute" do
    subject(:response) do
      patch execute_moves_project_step_move_path(step, move)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(moves_project_path(step)) }

    it do
      expect do
        response
        move.reload
      end.to change(move, :executed_at).from(nil)
    end

    context "when executed" do
      let(:move) { moves(:executed) }

      it do
        expect do
          response
          move.reload
        end.not_to change(move, :executed_at)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_project_path(step)) }
    end

    context "with an archived moves project" do
      let(:move) { moves(:archived) }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(moves_projects_path) }
    end
  end
end
