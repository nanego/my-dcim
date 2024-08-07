# frozen_string_literal: true

module Visualization
  class InfrastructuresController < ApplicationController
    def show
      @filter = Filter.new(params, %i[network_type islet_id])

      unless @filter.filled?
        islet_id = Islet.sorted.not_empty.has_name.distinct.first.id

        redirect_to islet_id:, network_type: :gbe
      end

      load_data! if turbo_frame_request?
    end

    private

    def load_data!
      @islet = Islet.find(@filter.islet_id)
      @room = @islet.room

      @servers = Server.includes(:frame, :stack, :ports, :cards => [:ports])
        .where.not(network_types: [])
      # .includes(:cards, :ports => [:connection => [:port, :cable =>[:connections => [:port => :card]]]]).
      @concentrateurs_ids = [383, 384, 1043, 1044]
      @concentrateurs = Server.where(id: @concentrateurs_ids).includes(:ports => :connection, :cards => [:ports => :connection])
      @switchs_lan_ids = @concentrateurs_ids | @servers.pluck(:id) # Switch LAN
      # TODO: Remove hard-coded values
      @hubs = {}

      unless Rails.env.test?
        @hubs = { "gbe" => { 4 => Server.find(383), 3 => Server.find(384) }, "10gbe" => { 4 => Server.find(1043), 3 => Server.find(1044) } } # Concentrateurs per room
      end

      @connections = {}
      @stacks = @servers.map(&:stack).uniq.compact
      @servers.each do |server|
        @connections[server.id] = server.directly_connected_servers_ids_with_color.reject { |conn| @switchs_lan_ids.exclude?(conn[:server_id]) }
      end
      @concentrateurs.each do |hub|
        @connections[hub.id] = hub.connected_servers_ids_through_twin_cards_with_color.reject { |conn| @switchs_lan_ids.exclude?(conn[:server_id]) }
      end

      # TODO: remove when hard-coded system will be removed
      @network_types = Modele::Network::TYPES.excluding("fiber")
      @network = @filter.network_type # TODO: take from params and raise error if not good

      return unless @room.id == 4 || @room.id == 3

      @hub = @hubs[@network][@room.id]
      @second_room = Room.find(@room.id == 4 ? 3 : 4)
      @second_hub = @hubs[@network][@second_room.id]
    end
  end
end
