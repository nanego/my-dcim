# frozen_string_literal: true

module Bulk
  class ManufacturersController < BaseController
    before_action :set_manufacturers

    def destroy
      respond_to do |format|
        if @manufacturers.map(&:destroy).all?
          format.html { redirect_to manufacturers_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Manufacturer.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to manufacturers_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Manufacturer.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_manufacturers
      authorize! @manufacturers = Manufacturer.where(id: params[:ids]), with: ManufacturerPolicy
    end
  end
end
