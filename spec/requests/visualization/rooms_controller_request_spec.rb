# frozen_string_literal: true

require "rails_helper"

RSpec.describe Visualization::RoomsController do
  let(:room) { rooms(:one) }

  describe "GET #index" do
    subject(:response) do
      get visualization_rooms_path(params:)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { {} }

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(room.name) }

    it :aggregate_failures do
      response

      expect(assigns(:sites)).to be_present
      expect(assigns(:frames)).to be_nil
    end

    context "with params gestion_id" do
      let(:params) { { gestion_id: 1 } }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:filtered_index) }
      it { expect(response.body).to include("Gestionnaire #{gestions(:one).name}") }

      it :aggregate_failures do
        response

        expect(assigns(:sites)).to be_present
        expect(assigns(:frames)).to be_present
      end
    end

    context "with params cluster_id" do
      let(:params) { { cluster_id: 1 } }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:filtered_index) }
      it { expect(response.body).to include("Cluster #{clusters(:cloud_c1).name}") }

      it :aggregate_failures do
        response

        expect(assigns(:sites)).to be_present
        expect(assigns(:frames)).to be_present
      end
    end
  end

  describe "GET #show" do
    subject(:response) do
      get visualization_room_path(room, params:)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { {} }

    include_context "with authenticated admin"

    context "with not found room" do
      let(:room) { Room.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing room" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
      it { expect(response.body).to include(room.name) }

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        response

        expect(assigns(:sites)).to be_present
        expect(assigns(:islet)).to be_nil
        expect(assigns(:air_conditioners)).to be_present
        expect(assigns(:room)).to be_present
        expect(assigns(:servers_per_frames)).to be_present
      end
    end

    context "with params islet" do
      let(:params) { { islet: "Islet1" } }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
      it { expect(response.body).to include(room.name) }

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        response

        expect(assigns(:sites)).to be_present
        expect(assigns(:islet)).to be_present
        expect(assigns(:air_conditioners)).to be_present
        expect(assigns(:room)).to be_present
        expect(assigns(:servers_per_frames)).to be_present
      end
    end
  end

  describe "GET #print" do
    subject(:response) do
      get print_visualization_room_path(room)
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

      it :aggregate_failures do
        response

        expect(assigns(:servers_per_frames)).to be_present
        expect(assigns(:room)).to be_present
      end
    end
  end
end
