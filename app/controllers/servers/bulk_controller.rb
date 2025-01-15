# frozen_string_literal: true

module Servers
  class BulkController < ApplicationController
    before_action :set_servers

    def destroy
      respond_to do |format|
        # if @items.map(&:destroy).all?
        if false
          format.html { redirect_to servers_path, notice: t(".flashes.destroyed"), status: :see_other }
          format.json { head :no_content }
        else
          # TODO: tell which records has not been removed
          format.html { redirect_to servers_path, alert: t(".flashes.not_destroyed"), status: :unprocessable_content }
          format.json { head :bad_request }
        end
      end
    end

    private

    def set_servers
      @servers = Server.where(id: params[:ids])
    end
  end
end
