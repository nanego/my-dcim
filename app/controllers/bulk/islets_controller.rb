# frozen_string_literal: true

module Bulk
  class IsletsController < BaseController
    before_action :set_islets

    def destroy
      respond_to do |format|
        if @islets.map(&:destroy).all?
          format.html { redirect_to islets_path, notice: t(".flashes.destroyed"), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to islets_path, alert: t(".flashes.not_destroyed"), status: :see_other }
        end
      end
    end

    private

    def set_islets
      @islets = Islet.where(id: params[:ids])
    end
  end
end
