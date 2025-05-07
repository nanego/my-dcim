# frozen_string_literal: true

module Bulk
  class AirConditionersController < BaseController
    before_action :set_air_conditioners

    def destroy
      respond_to do |format|
        if @air_conditioners.map(&:destroy).all?
          format.html { redirect_to air_conditioners_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: AirConditioner.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to air_conditioners_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: AirConditioner.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_air_conditioners
      @air_conditioners = AirConditioner.where(id: params[:ids])
    end
  end
end
