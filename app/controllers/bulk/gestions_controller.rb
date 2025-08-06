# frozen_string_literal: true

module Bulk
  class GestionsController < BaseController
    before_action :set_gestions

    def destroy
      respond_to do |format|
        if @gestions.map(&:destroy).all?
          format.html { redirect_to gestions_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Gestion.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to gestions_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Gestion.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_gestions
      @gestions = Gestion.where(id: params[:ids])
      authorize! @gestions, with: GestionPolicy
    end
  end
end
