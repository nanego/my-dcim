# frozen_string_literal: true

module Bulk
  class IsletsController < BaseController
    before_action :set_islets

    def destroy
      respond_to do |format|
        if @islets.map(&:destroy).all?
          format.html { redirect_to islets_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Islet.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to islets_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Islet.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_islets
      @islets = Islet.where(id: params[:ids])
    end
  end
end
