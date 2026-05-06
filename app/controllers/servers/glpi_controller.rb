# frozen_string_literal: true

module Servers
  class GlpiController < ApplicationController
    before_action :set_server

    def show
      return head :ok if @server.modele.category.glpi_sync_type_none?

      @equipment = @server.decorated.glpi_equipment
    rescue StandardError => e
      Rails.logger.warn "WARNING: couldn't get GLPI data because of an error: #{e.message}"
      @connection_error = e.message.to_s
    end

    private

    def set_server
      authorize! @server = Server.no_pdus.friendly_find_by_numero_or_name(params[:server_id])
    end
  end
end
