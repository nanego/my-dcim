# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/clusters" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    context "with clusters without associations" do
      let(:cluster_a) { Cluster.create!(name: "ClusterA") }
      let(:cluster_b) { Cluster.create!(name: "ClusterB") }

      before do
        cluster_a
        cluster_b
      end

      it do
        expect do
          delete bulk_clusters_path(ids: [cluster_a.id, cluster_b.id])
        end.to change(Cluster, :count).by(-2)
      end

      it do
        delete bulk_clusters_path(ids: [cluster_a.id, cluster_b.id])
        expect(response).to redirect_to(clusters_path)
      end
    end

    context "with a cluster with associations" do
      it do
        expect do
          delete bulk_clusters_path(ids: [clusters(:cloud_c1).id])
        end.not_to change(Cluster, :count)
      end

      it do
        delete bulk_clusters_path(ids: [clusters(:cloud_c1).id])
        expect(response).to redirect_to(clusters_path)
      end
    end
  end
end
