# frozen_string_literal: true

module Bulk
  class ManagersController < BaseController
    before_action :set_managers

    def destroy
      respond_to do |format|
        if @managers.map(&:destroy).all?
          format.html { redirect_to managers_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Manager.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to managers_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Manager.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_managers
      authorize! @managers = Manager.where(id: params[:ids])
    end
  end
end
