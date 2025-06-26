# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Visualization::InfrastructuresController" do
  let(:user) { User.create!(email: "user@example.com", password: "passwordpassword", role: "user") }

  before { sign_in user }

  describe "GET #show" do
    context "when filter is not filled" do
      before { get visualization_infrastructure_path }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(visualization_infrastructure_path(islet_id: 1, network_type: :gbe)) }
    end
  end

  describe "PATCH #edit_room_clusters" do
    subject(:response) do
      patch(edit_room_clusters_visualization_infrastructure_path, params:)

      @repsonse # rubocop:disable RSpec/InstanceVariable
    end

    let(:room) { rooms(:one) }
    let(:cluster) { clusters(:cloud_c1) }
    let(:params) { { room: { id: room.id, network_cluster_ids: [cluster.id] } } }

    it { expect(response).to redirect_to(root_path) }

    it do
      expect do
        response
        room.reload
      end.to change(room, :network_cluster_ids).from([]).to([cluster.id])
    end
  end
end
