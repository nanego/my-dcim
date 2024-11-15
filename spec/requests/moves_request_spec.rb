# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Moves" do
  let(:move) { moves(:one) }

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
