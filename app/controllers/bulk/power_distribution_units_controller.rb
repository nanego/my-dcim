# frozen_string_literal: true

module Bulk
  class PowerDistributionUnitsController < BaseController
    before_action :set_power_distribution_units

    def destroy
      respond_to do |format|
        if @power_distribution_units.map(&:destroy).all?
          # TODO: Use correct translation when available
          format.html { redirect_to power_distribution_units_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: "PDU"), status: :see_other }
        else
          # TODO: tell which records has not been removed
          # TODO: Use correct translation when available
          format.html { redirect_to power_distribution_units_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: "PDU"), status: :see_other }
        end
      end
    end

    private

    def set_power_distribution_units
      authorize! @power_distribution_units = Server.only_pdus.where(id: params[:ids]), with: PowerDistributionUnitPolicy
    end
  end
end
