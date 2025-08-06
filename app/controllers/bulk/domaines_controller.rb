# frozen_string_literal: true

module Bulk
  class DomainesController < BaseController
    before_action :set_domaines

    def destroy
      respond_to do |format|
        if @domaines.map(&:destroy).all?
          format.html { redirect_to domaines_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Domaine.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to domaines_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Domaine.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_domaines
      @domaines = Domaine.where(id: params[:ids])
      authorize! @domaines, with: DomainePolicy
    end
  end
end
