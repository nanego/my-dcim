# frozen_string_literal: true

module Netsight
  class Client
    module Types
      include Dry.Types()
    end

    class Port < Dry::Struct
      DEFAULT_VLAN = 1
      PORTS_PER_SLOT = 1000
      # entityData.vlanSupported of a switch whose VLANs Netsight reads over SNMP
      VLANS_COLLECTED = 1
      VLAN_ENTRY = /\A(?<vid>\d+)\[.*\] (?<mode>Tagged|Untagged)\z/

      attribute :sys_name, Types::String.optional
      attribute :if_name, Types::String.optional
      attribute :oper_status, Types::String.optional
      attribute :speed, Types::String.optional
      attribute :description, Types::String.optional
      attribute :lag_master_if_index, Types::Integer.optional
      attribute :tagged, Types::Array.of(Types::Integer)
      attribute :untagged, Types::Array.of(Types::Integer)
      attribute :vlans_collected, Types::Bool.default(true)
      attribute? :scanned_at, Types::Time.optional

      def self.from_api(device)
        entity_data = device["entityData"] || {}

        build(device["sysName"], entity_data["port"] || {}, vlans_collected: vlans_collected?(entity_data),
                                                            scanned_at: scan_time(entity_data["lastFullScan"]))
      end

      # The VLANs come from what Netsight polls on the switch: deviceData holds
      # the VLANs Netsight would configure, which drift from the switch
      def self.build(sys_name, entity, vlans_collected:, scanned_at: nil)
        vlans = vlans_collected ? parse_vlan_list(entity["vlanList"]) : { tagged: [], untagged: [] }

        new(sys_name:,
            if_name: entity["ifName"],
            oper_status: entity["formattedOperStatus"],
            speed: entity["formattedSpeed"],
            description: entity["ifAlias"].presence,
            lag_master_if_index: (entity["lagMasterIndex"] if entity["isLagContributor"]),
            tagged: vlans[:tagged].sort,
            untagged: vlans[:untagged].sort,
            vlans_collected:,
            scanned_at:)
      end

      def self.vlans_collected?(entity_data)
        entity_data["vlanSupported"] == VLANS_COLLECTED
      end

      # ["1573[CS_1573] Tagged", "1656[ADMIN] Untagged"] => { tagged: [1573], untagged: [1656] }
      def self.parse_vlan_list(entries)
        entries.to_a.each_with_object({ tagged: [], untagged: [] }) do |entry, vlans|
          match = VLAN_ENTRY.match(entry) or raise Error, "unexpected Netsight VLAN entry: #{entry.inspect}"
          vlans[match[:mode].downcase.to_sym] << match[:vid].to_i
        end
      end

      # Netsight gives epoch milliseconds, and nothing for a switch it can't reach
      def self.scan_time(milliseconds)
        Time.zone.at(milliseconds / 1000.0) if milliseconds.to_i.positive?
      end

      def self.normalize_vlans(vlans)
        vlans.to_s.downcase.split(/[\s,]+/).compact_blank.sort
      end

      # DCIM users also write free text in the VLAN field ("All", "f1", "Trunk")
      def self.vlan_list?(vlans)
        normalize_vlans(vlans).all? { |vlan| vlan.match?(/\A[ut]\d+\z/) }
      end

      # The default VLAN left untagged on a trunk is the switch default, DCIM omits it
      def dcim_vlans
        shown_untagged = tagged.any? ? untagged - [DEFAULT_VLAN] : untagged
        (shown_untagged.map { |vid| "u#{vid}" } + tagged.map { |vid| "t#{vid}" }).join(", ")
      end

      def matches_dcim?(vlans)
        self.class.normalize_vlans(vlans) == self.class.normalize_vlans(dcim_vlans)
      end

      def default_vlan_only?
        tagged.empty? && untagged == [DEFAULT_VLAN]
      end

      def no_vlan?
        tagged.empty? && untagged.empty?
      end

      def lag_member?
        lag_master_if_index.present?
      end

      def lag_master_name
        "#{lag_master_if_index / PORTS_PER_SLOT}:#{lag_master_if_index % PORTS_PER_SLOT}" if lag_member?
      end
    end
  end
end
