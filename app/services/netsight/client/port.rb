# frozen_string_literal: true

module Netsight
  class Client
    module Types
      include Dry.Types()
    end

    class Port < Dry::Struct
      DEFAULT_VLAN = 1
      PORTS_PER_SLOT = 1000

      attribute :sys_name, Types::String.optional
      attribute :if_name, Types::String.optional
      attribute :oper_status, Types::String.optional
      attribute :speed, Types::String.optional
      attribute :description, Types::String.optional
      attribute :lag_master_if_index, Types::Integer.optional
      attribute :tagged, Types::Array.of(Types::Integer)
      attribute :untagged, Types::Array.of(Types::Integer)

      def self.from_api(device)
        build(device["sysName"], device.dig("entityData", "port") || {}, device.dig("deviceData", "port") || {})
      end

      def self.build(sys_name, entity, data)
        new(sys_name:,
            if_name: entity["ifName"],
            oper_status: entity["formattedOperStatus"],
            speed: entity["formattedSpeed"],
            description: entity["ifAlias"].presence,
            lag_master_if_index: (entity["lagMasterIndex"] if entity["isLagContributor"]),
            tagged: data["tagged"].to_a.sort,
            untagged: data["untagged"].to_a.sort)
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
