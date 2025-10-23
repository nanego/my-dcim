# frozen_string_literal: true

require "rails_helper"

RSpec.describe RoomsController do
  let(:room) { rooms(:one) }

  describe "GET #index" do
    subject(:response) do
      get rooms_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    before { sign_in users(:admin) }

    it { expect { response }.to have_authorized_scope(:active_record_relation).with(RoomPolicy) }
    it { expect { response }.to have_rubanok_processed(Room.all).with(RoomsProcessor) }
    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it do
      response
      expect(assigns(:filter)).to be_present
    end
  end

  describe "GET #new" do
    subject(:response) do
      get new_room_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post(rooms_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { room: { name: "Room 1", site_id: sites(:one).id } } }

    include_context "with authenticated admin"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(room_path(assigns(:room))) }
      it { expect { response }.to change(Room, :count).by(1) }
    end

    context "with invalid parameters" do
      let(:params) { { room: { name: "Room 1", site_id: 9999 } } }

      it { expect(response).to render_template(:new) }
      it { expect { response }.not_to change(Room, :count) }
    end

    context "without attributes" do
      let(:params) { { frame: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "GET #print" do
    subject(:response) do
      get print_visualization_room_path(room)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

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
      patch(room_path(room), params:, headers: { REFERER: "/visualization/infrastructure" })

      @response # rubocop:disable RSpec/InstanceVariable
    end

    before do
      sign_in users(:admin)
    end

    context "with invalid data" do
      let(:params) { { room: { site_id: 123_456 } } }

      it { expect(response).to have_http_status(:unprocessable_content) }
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

      it { expect(response).to redirect_to(visualization_infrastructure_path) }

      it do
        expect do
          response
          room.reload
        end.to change(room, :network_cluster_ids).from([]).to([cluster.id])
      end
    end
  end
end
