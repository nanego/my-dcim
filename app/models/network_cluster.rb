# frozen_string_literal: true

class NetworkCluster
  attr_reader :network_types

  def initialize(room:, network_types:)
    @room = room
    @clusters = room.network_clusters
    @network_types = Array(network_types)
  end

  def servers
    @servers ||= Server.where(cluster: @clusters)
      .where("network_types && ARRAY[?]::varchar[]", network_types)
  end

  def room_server
    @room_server ||= servers.find { |s| s.room.id == @room.id }
  end

  def other_rooms_servers
    @other_rooms_servers ||= servers.reject { |s| s.room.id == @room.id }
  end
end
