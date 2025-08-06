# frozen_string_literal: true

module Bulk
  class ModelesController < BaseController
    before_action :set_modeles

    def destroy
      respond_to do |format|
        if @modeles.map(&:destroy).all?
          format.html { redirect_to modeles_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Modele.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to modeles_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Modele.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_modeles
      @modeles = Modele.where(id: params[:ids])
      authorize! @modeles, with: ModelePolicy
    end
  end
end
