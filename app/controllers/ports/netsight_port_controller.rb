# frozen_string_literal: true

module Ports
  class NetsightPortController < ApplicationController
    before_action :set_port

    def show
      return unless (@configured = NetsightClient.configured?)

      @demo = NetsightClient.demo?

      client = NetsightClient.new
      @location = NetsightPortLocator.new(client:).call(@port)
      @netsight_port = client.port(ip: @location.ip, if_index: @location.if_index) if @location.found?
    rescue StandardError => e
      Rails.logger.warn "WARNING: couldn't get Netsight data because of an error: #{e.message}"
      @connection_error = e.message.to_s
    end

    private

    def set_port
      authorize! @port = Port.find(params[:port_id]), to: :show?
    end
  end
end
