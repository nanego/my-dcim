# frozen_string_literal: true

module Bulk
  class AirConditionerModelsController < BaseController
    before_action :set_air_conditioner_models

    def destroy
      respond_to do |format|
        if @air_conditioner_models.map(&:destroy).all?
          format.html do
            redirect_to air_conditioner_models_path,
                        notice: t("bulk.resource.destroy.flashes.destroyed", resource: AirConditionerModel.model_name.human(count: 2)),
                        status: :see_other
          end
        else
          # TODO: tell which records has not been removed
          format.html do
            redirect_to air_conditioner_models_path,
                        alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: AirConditionerModel.model_name.human),
                        status: :see_other
          end
        end
      end
    end

    private

    def set_air_conditioner_models
      authorize! @air_conditioner_models = AirConditionerModel.where(id: params[:ids])
    end
  end
end
