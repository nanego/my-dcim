# frozen_string_literal: true

module Servers
  class GlpiController < ApplicationController
    before_action :set_server

    def show
      @computer = @server.decorated.glpi_equipment
    end

    private

    def set_server
      authorize! @server = Server.no_pdus.friendly_find_by_numero_or_name(params[:server_id])
    end
  end
end
