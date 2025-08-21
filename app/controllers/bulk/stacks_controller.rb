# frozen_string_literal: true

module Bulk
  class StacksController < BaseController
    before_action :set_stacks

    def destroy
      respond_to do |format|
        if @stacks.map(&:destroy).all?
          format.html { redirect_to stacks_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Stack.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to stacks_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Stack.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_stacks
      authorize! @stacks = Stack.where(id: params[:ids])
    end
  end
end
