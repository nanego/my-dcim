# frozen_string_literal: true

module Netsight
  # Finds the Netsight device and stack slot behind a DCIM server: by serial
  # number first, then by name ("sysName:SlotN"), and reports where they disagree
  class SwitchMatcher
    EXTREME_SERIAL = /\A\d{4}[A-Z]-\d{5}\z/

    Match = Data.define(:server, :ip, :slot, :issue, :netsight_serial)

    def initialize(client)
      @client = client
      @serials = client.serial_index
      @serial_by_location = @serials.invert
    end

    def call(server)
      by_serial = @serials[Client::DeviceSerials.normalize(server.numero)]
      by_name = name_location(server)
      location = by_serial || by_name or return

      Match.new(server:, ip: location.first, slot: location.last, issue: issue(server, by_serial, by_name),
                netsight_serial: @serial_by_location[location])
    end

    private

    def name_location(server)
      sys_name, slot = PortLocator.parse_name(server.name)
      ip = sys_name && @client.known_device_ip(sys_name)
      [ip, slot] if ip
    end

    def issue(server, by_serial, by_name)
      if by_serial && by_name && by_serial != by_name then :name_serial_mismatch
      elsif by_serial.nil? && server.numero.to_s.upcase.match?(EXTREME_SERIAL) then :serial_not_in_netsight
      elsif by_serial.nil? && @serial_by_location[by_name] then :serial_to_complete
      end
    end
  end
end
