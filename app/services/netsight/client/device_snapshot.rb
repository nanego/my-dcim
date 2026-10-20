# frozen_string_literal: true

module Netsight
  class Client
    DeviceSnapshot = Data.define(:ports, :links, :vlans_collected) do
      def self.from_api(device, ip:)
        vlans_collected = Port.vlans_collected?(device["entityData"] || {})

        new(ports: ports_from(device, vlans_collected), links: links_from(device, ip), vlans_collected:)
      end

      def self.ports_from(device, vlans_collected)
        device.dig("entityData", "allPorts").to_a.each_with_object({}) do |entity, ports|
          next if entity["ifName"].blank?

          ports[entity["ifName"]] = Port.build(device["sysName"], entity, vlans_collected:)
        end
      end

      def initialize(ports:, links:, vlans_collected: true) = super

      # Netsight lists each link with its two ends in no particular order, sometimes twice
      def self.links_from(device, ip)
        device["links"].to_a.filter_map do |link|
          local, peer = link["deviceIp2"] == ip ? [2, 1] : [1, 2]
          next if link["deviceIp#{local}"] != ip

          Link.new(if_name: link["ifName#{local}"], peer_ip: link["deviceIp#{peer}"], peer_if_name: link["ifName#{peer}"],
                   protocol: link["discoveryProto"], type: link["formattedType"], status: link["status"])
        end.uniq
      end
    end
  end
end
