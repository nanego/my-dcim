# frozen_string_literal: true

module Bulk
  class PowerDistributionUnitTypesController < BaseController
    before_action :set_power_distribution_unit_types

    def destroy
      respond_to do |format|
        if @power_distribution_unit_types.map(&:destroy).all?
          format.html do
            redirect_to power_distribution_unit_types_path,
                        notice: t("bulk.resource.destroy.flashes.destroyed", resource: PowerDistributionUnitType.model_name.human.pluralize),
                        status: :see_other
          end
        else
          # TODO: tell which records has not been removed
          format.html do
            redirect_to power_distribution_unit_types_path,
                        alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: PowerDistributionUnitType.model_name.human),
                        status: :see_other
          end
        end
      end
    end

    private

    def set_power_distribution_unit_types
      authorize! @power_distribution_unit_types = PowerDistributionUnitType.where(id: params[:ids])
    end

    def default_authorization_policy_class
      PowerDistributionUnitTypePolicy
    end
  end
end
