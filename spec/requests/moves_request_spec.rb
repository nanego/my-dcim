# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Moves" do
  let(:move) { moves(:one) }

  describe "GET #index" do
    include_context "with authenticated user"

    before { get moves_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
  end

  describe "GET #show" do
    subject(:response) do
      get move_path(move)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

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
      get new_move_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }

    context "with a params[:server_id] passed" do
      subject(:response) do
        get new_move_path(server_id: server.id)

        # NOTE: used to simplify usage and custom test done in final spec file.
        @response # rubocop:disable RSpec/InstanceVariable
      end

      let(:server) { servers(:one) }

      before { response }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:new) }

      it { expect(server).to eq(assigns(:move).moveable) }
    end
  end

  describe "POST #create" do
    subject(:response) do
      post moves_path, params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) do
      {
        moveable_type: "Server",
        moveable_id: servers(:one).id,
        frame_id: frames(:one).id,
        prev_frame_id: frames(:two).id,
        position: 40
      }
    end
    let(:params) { { move: valid_attributes } }

    include_context "with authenticated user"

    context "with valid parameters" do
      it { expect { response }.to change(Move, :count).by(1) }
      it { expect(response).to redirect_to(edit_move_path(assigns(:move))) }
    end

    context "without attributes" do
      let(:params) { { move: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "GET #edit" do
    include_context "with authenticated user"

    before { get edit_move_path(move) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch move_path(move), params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { position: 8 } }
    let(:params) { { move: valid_attributes } }

    include_context "with authenticated user"

    context "with valid parameters" do
      it do
        expect do
          response
          move.reload
        end.to change(move, :position).to(8)
      end

      it { expect(response).to redirect_to(edit_move_path(assigns(:move))) }
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
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete move_path(move)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it do
      expect do
        response
      end.to change(Move, :count).by(-1)
    end

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(moves_path) }
  end

  describe "GET #execute" do
    subject(:response) do
      get execute_move_path(move)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(moves_path) }

    it do
      expect do
        response
      end.to change(Move, :count).by(-1)
    end
  end

  describe "GET #print" do
    subject(:response) do
      get print_moves_path(move.frame_id)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    context "with not found frame" do
      before { move.frame_id = 999_999_999 }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing move" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:print) }
      it { expect(response).to render_template("layouts/pdf") }
    end
  end
end
