# frozen_string_literal: true

module Netsight
  class Client
    # Netsight lists the physical entities of a device: a stack has a "Slot-N"
    # container per member, a standalone switch a single "Switch" container
    module DeviceSerials
      CONTAINER_CLASS = 5
      SLOT_NAME = /\ASlot-(?<slot>\d+)\z/

      # Several devices per request, under the aliases d0, d1...
      def self.query(ips)
        aliases = ips.each_with_index.map do |ip, i|
          %(d#{i}: device(ip: "#{ip}") { ip deviceData { serialNumber }
            entityData { deviceTopology { entPhysicalClass entPhysicalName entPhysicalSerialNum } } })
        end

        "{ network { #{aliases.join(" ")} } }"
      end

      def self.from_api(device)
        containers = device.dig("entityData", "deviceTopology").to_a.select do |entity|
          entity["entPhysicalClass"] == CONTAINER_CLASS && normalize(entity["entPhysicalSerialNum"]).present?
        end

        slots = containers.filter_map do |entity|
          match = SLOT_NAME.match(entity["entPhysicalName"].to_s) or next
          [normalize(entity["entPhysicalSerialNum"]), [device["ip"], match[:slot].to_i]]
        end
        return slots.to_h if slots.any?

        serial = normalize(containers.first&.dig("entPhysicalSerialNum")) || normalize(device.dig("deviceData", "serialNumber"))
        serial ? { serial => [device["ip"], 1] } : {}
      end

      def self.normalize(serial)
        serial.to_s.strip.upcase.presence
      end
    end
  end
end
