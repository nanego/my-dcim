# frozen_string_literal: true

module Bulk
  class ArchitecturesController < BaseController
    before_action :set_architectures

    def destroy
      respond_to do |format|
        if @architectures.map(&:destroy).all?
          format.html { redirect_to architectures_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Architecture.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to architectures_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Architecture.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_architectures
      @architectures = Architecture.where(id: params[:ids])
      authorize! @architectures, with: ArchitecturePolicy
    end
  end
end
