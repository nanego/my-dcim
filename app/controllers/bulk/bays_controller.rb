# frozen_string_literal: true

module Bulk
  class BaysController < BaseController
    before_action :set_bays

    def destroy
      respond_to do |format|
        if @bays.map(&:destroy).all?
          format.html { redirect_to bays_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Bay.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to bays_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Bay.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_bays
      authorize! @bays = Bay.where(id: params[:ids]), with: BayPolicy
    end
  end
end
