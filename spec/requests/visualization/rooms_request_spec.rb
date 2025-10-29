# frozen_string_literal: true

require "rails_helper"

RSpec.describe Visualization::RoomsController do
  let(:room) { rooms(:one) }

  before do
    sign_in users(:admin)
  end

  describe "GET #index" do
    let(:params) { {} }

    before { get visualization_rooms_path(params:) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(room.name) }
    it { expect(assigns(:sites)).not_to be_nil }
    it { expect(assigns(:frames)).to be_nil }

    context "with params gestion_id" do
      let(:params) { { gestion_id: 1 } }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:filtered_index) }
      it { expect(response.body).to include("Gestionnaire #{gestions(:one).name}") }
      it { expect(assigns(:sites)).not_to be_nil }
      it { expect(assigns(:frames)).not_to be_nil }
    end

    context "with params cluster_id" do
      let(:params) { { cluster_id: 1 } }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:filtered_index) }
      it { expect(response.body).to include("Cluster #{clusters(:cloud_c1).name}") }
      it { expect(assigns(:sites)).not_to be_nil }
      it { expect(assigns(:frames)).not_to be_nil }
    end
  end
end
