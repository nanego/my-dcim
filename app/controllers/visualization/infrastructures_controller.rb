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
      @concentrateurs_ids = [383, 384, 1043, 1044]
      @concentrateurs = Server.where(id: @concentrateurs_ids)

      # fresh_when last_modified: [@servers.maximum(:updated_at), @concentrateurs.maximum(:updated_at)].max

      @servers = @servers.includes(:frame, :stack, :ports, cards: [:ports])
      @hubs = RoomHub.for_room(@room, network_types: @filter.network_type)

      @switchs_lan_ids = (@hubs.pluck(:server_a) + @hubs.pluck(:server_b)).compact | @servers.pluck(:id) # Switch LAN

      @connections = {}
      @stacks = @servers.map(&:stack).uniq.compact
      @servers.each do |server|
        @connections[server.id] = server.directly_connected_servers_ids_with_color.reject { |conn| @switchs_lan_ids.exclude?(conn[:server_id]) }
      end
      @hubs.each do |hub|
        @connections[hub.server_a.id] = hub.server_a.connected_servers_ids_through_twin_cards_with_color.reject { |conn| @switchs_lan_ids.exclude?(conn[:server_id]) }
        @connections[hub.server_b.id] = hub.server_b.connected_servers_ids_through_twin_cards_with_color.reject { |conn| @switchs_lan_ids.exclude?(conn[:server_id]) }
      end

      @network = @filter.network_type # TODO: take from params and raise error if not good

      # @hub = @hubs[@network][@room.id]
      # @second_room = Room.find(@room.id == 4 ? 3 : 4)
      # @second_hub = @hubs[@network][@second_room.id]
    end
  end
end
