# frozen_string_literal: true

module Netsight
  class Client
    DeviceSnapshot = Data.define(:ports, :links) do
      def self.from_api(device, ip:)
        new(ports: ports_from(device), links: links_from(device, ip))
      end

      def self.ports_from(device)
        data_by_if_index = device.dig("deviceData", "ports").to_a.index_by { |data| data["ifIndex"] }

        device.dig("entityData", "allPorts").to_a.each_with_object({}) do |entity, ports|
          next if entity["ifName"].blank?

          ports[entity["ifName"]] = Port.build(device["sysName"], entity, data_by_if_index[entity["ifIndex"]] || {})
        end
      end

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
