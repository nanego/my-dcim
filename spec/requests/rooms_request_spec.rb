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

      @response # rubocop:disable RSpec/InstanceVariable
    end

    before do
      sign_in users(:one)
    end

    context "with invalid data" do
      let(:params) { { room: { site_id: 123_456 } } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template(:edit) }
    end

    context "with valid data" do
      let(:params) { { room: { name: "newName" } } }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(room_path("newname")) }

      it do
        expect do
          response
          room.reload
        end.to change(room, :name).from("S1").to("newName")
      end
    end

    context "when request back on succes" do
      let(:cluster) { clusters(:cloud_c1) }
      let(:params) { { room: { network_cluster_ids: [cluster.id] }, redirect_to_on_success: :back } }

      it { expect(response).to redirect_to(room_path(room)) }

      it do
        expect do
          response
          room.reload
        end.to change(room, :network_cluster_ids).from([]).to([cluster.id])
      end
    end
  end
end
