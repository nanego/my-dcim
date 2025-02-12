# frozen_string_literal: true

module Visualization
  class InfrastructuresController < BaseController
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

      @servers = Server.where.not(network_types: [])
      # .includes(:cards, :ports => [:connection => [:port, :cable =>[:connections => [:port => :card]]]]).

      # fresh_when last_modified: [@servers.maximum(:updated_at), @concentrateurs.maximum(:updated_at)].max

      @servers = @servers.includes(:frame, :stack, :ports, cards: [:ports])
      # @hubs = RoomHub.for_room(@room, network_types: @filter.network_type)
      @network_cluster = NetworkCluster.new(room: @room, network_types: @filter.network_type)
      @concentrateurs_ids = @network_cluster.servers.pluck(:id)

      @switchs_lan_ids = @network_cluster.servers.pluck(:id) | @servers.pluck(:id) # Switch LAN

      @connections = {}
      @stacks = @servers.map(&:stack).uniq.compact
      @servers.each do |server|
        @connections[server.id] = server.directly_connected_servers_ids_with_color.reject { |conn| @switchs_lan_ids.exclude?(conn[:server_id]) }
      end
      @network_cluster.servers.each do |server|
        @connections[server.id] = server.connected_servers_ids_through_twin_cards_with_color.reject { |conn| @switchs_lan_ids.exclude?(conn[:server_id]) }
        @connections[server.id] = server.connected_servers_ids_through_twin_cards_with_color.reject { |conn| @switchs_lan_ids.exclude?(conn[:server_id]) }
      end

      @network = @filter.network_type # TODO: take from params and raise error if not good
    end
  end
end
