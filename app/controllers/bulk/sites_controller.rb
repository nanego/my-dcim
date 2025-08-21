# frozen_string_literal: true

module Bulk
  class SitesController < BaseController
    before_action :set_sites

    def destroy
      respond_to do |format|
        if @sites.map(&:destroy).all?
          format.html { redirect_to sites_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Site.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to sites_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Site.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_sites
      authorize! @sites = Site.where(id: params[:ids])
    end
  end
end
