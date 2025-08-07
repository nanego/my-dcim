# frozen_string_literal: true

module Bulk
  class ClustersController < BaseController
    before_action :set_clusters

    def destroy
      respond_to do |format|
        if @clusters.map(&:destroy).all?
          format.html { redirect_to clusters_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Cluster.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to clusters_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Cluster.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_clusters
      @clusters = Cluster.where(id: params[:ids])
      authorize! @clusters, with: ClusterPolicy
    end
  end
end
