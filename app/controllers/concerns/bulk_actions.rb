# frozen_string_literal: true

module BulkActions
  extend ActiveSupport::Concern

  included do
    def bulk_manage
      @items = params[:item_ids].map { |id| resource_class.find(id) }

      if params[:bulk_destroy]
        bulk_destroy
      else
        redirect_back fallback_location: root_path
      end
    end

    private

    def bulk_destroy
      bulk_result = @items.map(&:destroy).all?

      respond_to do |format|
        if bulk_result
          # TODO: Create locales for bulk actions
          format.html { redirect_to index_path(search_params), notice: t("servers.destroy.flashes.destroyed") }
          format.json { head :no_content }
        else
          format.html { redirect_to index_path(search_params), alert: t("servers.destroy.flashes.not_destroyed") }
          format.json { head :bad_request }
        end
      end
    end

    def resource_class
      controller_name.classify.constantize
    end

    def index_path(params)
      polymorphic_path(resource_class, params)
    end
  end
end
