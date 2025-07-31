# frozen_string_literal: true

module Bulk
  class RoomsController < BaseController
    before_action :set_rooms

    def destroy
      respond_to do |format|
        if @rooms.map(&:destroy).all?
          format.html { redirect_to rooms_path, notice: t("bulk.resource.destroy.flashes.destroyed", resource: Room.model_name.human.pluralize), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to rooms_path, alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: Room.model_name.human), status: :see_other }
        end
      end
    end

    private

    def set_rooms
      authorize! @rooms = Room.where(id: params[:ids]), with: RoomPolicy
    end
  end
end
