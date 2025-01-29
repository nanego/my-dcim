# frozen_string_literal: true

module Bulk
  class ServersController < BaseController
    before_action :set_servers

    def destroy
      respond_to do |format|
        if @servers.map(&:destroy).all?
          format.html { redirect_to servers_path, notice: t(".flashes.destroyed"), status: :see_other }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to servers_path, alert: t(".flashes.not_destroyed"), status: :see_other }
        end
      end
    end

    private

    def set_servers
      @servers = Server.where(id: params[:ids])
    end
  end
end
