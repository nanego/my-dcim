# frozen_string_literal: true

class Move
  class Connection < ApplicationRecord
    has_changelog

    belongs_to :move
    belongs_to :port_from, class_name: "Port"
    belongs_to :port_to, class_name: "Port", optional: true

    scope :not_executed, -> { where(executed_at: nil) }

    def ports
      [port_from, port_to].compact
    end

    def self.per_moves_and_servers(moves, servers)
      servers_ports_ids = servers.map(&:ports).flatten.map(&:id)
      Move::Connection.where(move: moves).where("port_from_id IN (?) OR port_to_id IN (?)", servers_ports_ids, servers_ports_ids)
    end

    def execute!
      return if executed?

      transaction(requires_new: true) do
        port_from.connect_to_port(port_to, cable_name, cable_color, vlans)

        update!(executed_at: Time.zone.now)
      end
    end

    def executed?
      executed_at?
    end
  end
end
