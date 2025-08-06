# frozen_string_literal: true

module Bulk
  class CategoriesController < BaseController
    before_action :set_categories

    def destroy
      respond_to do |format|
        if @categories.map(&:destroy).all?
          format.html { redirect_to categories_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Category.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to categories_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Category.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_categories
      @categories = Category.where(id: params[:ids])
      authorize! @categories, with: CategoryPolicy
    end
  end
end
