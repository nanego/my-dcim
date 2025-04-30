# frozen_string_literal: true

module Bulk
  class CardTypesController < BaseController
    before_action :set_card_types

    def destroy
      respond_to do |format|
        if @card_types.map(&:destroy).all?
          format.html { redirect_to card_types_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: CardType.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to card_types_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: CardType.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_card_types
      @card_types = CardType.where(id: params[:ids])
    end
  end
end
