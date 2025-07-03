# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rooms" do
  let(:room) { rooms(:one) }

  describe "GET #print" do
    subject(:response) do
      get print_visualization_room_path(room)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    context "with not found room" do
      let(:room) { Room.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing room" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:print) }
      it { expect(response).to render_template("layouts/pdf") }
    end
  end

  describe "PATCH #update" do
    subject(:response) do
      patch(room_path(room), params:)

      @repsonse # rubocop:disable RSpec/InstanceVariable
    end

    before do
      sign_in users(:one)
    end

    context "when infrastructure request" do
      let(:cluster) { clusters(:cloud_c1) }
      let(:params) { { room: { id: room.id, network_cluster_ids: [cluster.id] }, infrastructure: true } }

      it { expect(response).to redirect_to(root_path) }

      it do
        expect do
          response
          room.reload
        end.to change(room, :network_cluster_ids).from([]).to([cluster.id])
      end
    end
  end
end
