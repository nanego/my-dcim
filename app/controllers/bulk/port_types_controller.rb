# frozen_string_literal: true

module Bulk
  class PortTypesController < BaseController
    before_action :set_port_types

    def destroy
      respond_to do |format|
        if @port_types.map(&:destroy).all?
          format.html { redirect_to port_types_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: PortType.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to port_types_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: PortType.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_port_types
      @port_types = PortType.where(id: params[:ids])
    end
  end
end
