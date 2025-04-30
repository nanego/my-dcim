# frozen_string_literal: true

module Bulk
  class RoomsController < BaseController
    before_action :set_rooms

    def destroy
      respond_to do |format|
        if @rooms.map(&:destroy).all?
          format.html { redirect_to rooms_path, notice: t(".flashes.destroyed"), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to rooms_path, alert: t(".flashes.not_destroyed"), status: :see_other }
        end
      end
    end

    private

    def set_rooms
      @rooms = Room.where(id: params[:ids])
    end
  end
end
