# frozen_string_literal: true

class MovedConnection < ApplicationRecord
  has_changelog

  belongs_to :port_from, class_name: 'Port'
  belongs_to :port_to, class_name: 'Port', optional: true

  def self.per_servers(servers)
    servers_ports_ids = servers.map(&:ports).flatten.map(&:id)
    MovedConnection.where('port_from_id IN (?) OR port_to_id IN (?)', servers_ports_ids, servers_ports_ids)
  end

  def ports
    [port_from, port_to].compact
  end

  def cable_color
    color
  end

  def execute!
    port_from.connect_to_port(port_to, cablename, color, vlans)
    delete # TODO: does this must be removed ?
  end

  def cable_name
    cablename
  end
end
