# frozen_string_literal: true

require "rails_helper"

RSpec.describe ClustersController do
  let(:cluster) { clusters(:cloud_c1) }

  describe "GET #index" do
    subject(:response) do
      get clusters_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(cluster.name) }

    it { expect { response }.to have_rubanok_processed(Cluster.all).with(ClustersProcessor) }

    it do
      response
      expect(assigns(:clusters)).not_to be_nil
    end
  end

  describe "GET #new" do
    subject(:response) do
      get new_cluster_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post(clusters_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { cluster: { name: "Arhitecture 1" } } }

    include_context "with authenticated admin"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(cluster_path(assigns(:cluster))) }
      it { expect { response }.to change(Cluster, :count).by(1) }
    end

    context "without attributes" do
      let(:params) { { cluster: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end
end
