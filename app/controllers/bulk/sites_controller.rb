# frozen_string_literal: true

module Bulk
  class SitesController < BaseController
    before_action :set_sites

    def destroy
      respond_to do |format|
        if @sites.map(&:destroy).all?
          format.html { redirect_to sites_path, notice: t(".flashes.destroyed"), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to sites_path, alert: t(".flashes.not_destroyed"), status: :see_other }
        end
      end
    end

    private

    def set_sites
      @sites = Site.where(id: params[:ids])
    end
  end
end
