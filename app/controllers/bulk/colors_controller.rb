# frozen_string_literal: true

module Bulk
  class ColorsController < BaseController
    before_action :set_colors

    def destroy
      respond_to do |format|
        if @colors.map(&:destroy).all?
          format.html { redirect_to colors_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Color.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to colors_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Color.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_colors
      @colors = Color.where(id: params[:ids])
    end
  end
end
