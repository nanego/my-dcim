# frozen_string_literal: true

module Bulk
  class CablesController < BaseController
    before_action :set_cables

    def destroy
      respond_to do |format|
        if @cables.map(&:destroy).all?
          format.html { redirect_to cables_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Cable.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to cables_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Cable.model_name.human), status: :see_other }
        end
      end
    end

    private

    def scoped_cables
      authorized_scope(Cable.all)
    end

    def set_cables
      authorize! @cables = scoped_cables.where(id: params[:ids])
    end
  end
end
