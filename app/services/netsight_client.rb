# frozen_string_literal: true

require "faraday"
require "json"

class NetsightClient
  PROXY_URL = Rails.application.credentials.proxy_url

  DEVICES_CACHE_KEY = "netsight/devices"
  DEVICES_CACHE_TTL = 1.hour
  DEVICES_QUERY = "{ network { devices { ip sysName nickName } } }"
  TIMEOUTS = { open_timeout: 3, timeout: 10 }.freeze
  DEMO_IP = "10.128.5.63"

  class Error < StandardError; end

  attr_reader :connection

  def self.live?
    Rails.env.production? || NetsightApiConfig.local_server
  end

  def self.configured?
    !live? || NetsightApiConfig.url.present?
  end

  def self.demo?
    Rails.env.development? && !live?
  end

  def initialize
    @connection = if self.class.live?
                    Faraday.new(NetsightApiConfig.url, proxy: PROXY_URL, request: TIMEOUTS) do |f|
                      f.request :authorization, :basic, NetsightApiConfig.username, NetsightApiConfig.password
                      f.response :raise_error
                    end
                  else
                    Faraday.new { |b| b.adapter(:test, stubs) }
                  end
  end

  def device_ip(name)
    return DEMO_IP if demo? && name.present?

    devices_index[name.to_s.downcase]
  end

  delegate :demo?, to: :class

  def port(ip:, if_index:)
    raise ArgumentError, "invalid device IP: #{ip.inspect}" unless ip.to_s.match?(/\A[\h.:]+\z/)

    port_filter = "port(ifIndex: #{Integer(if_index)})"
    device = graphql(<<~GRAPHQL).dig("network", "device")
      { network { device(ip: "#{ip}") { sysName
        entityData { #{port_filter} { ifName formattedOperStatus formattedSpeed ifAlias isLagContributor lagMasterIndex } }
        deviceData { #{port_filter} { tagged untagged portPvid } }
      } } }
    GRAPHQL

    Port.from_api(device) if device&.dig("entityData", "port")
  end

  private

  def graphql(query)
    body = JSON.parse(connection.get("", query:).body)
    raise Error, body["errors"].pluck("message").join(", ") if body["errors"].present?

    body.fetch("data")
  end

  # Nicknames go in first so that a sysName wins over another device's nickname
  def devices_index
    @devices_index ||= Rails.cache.fetch(DEVICES_CACHE_KEY, expires_in: DEVICES_CACHE_TTL) do
      devices = graphql(DEVICES_QUERY).dig("network", "devices").to_a

      %w[nickName sysName].each_with_object({}) do |key, index|
        devices.each { |device| index[device[key].downcase] = device["ip"] if device[key].present? }
      end
    end
  end

  def stubs
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get(%r{\A/?\z}) do |env|
        fixture = env.params["query"].to_s.include?("devices") ? "netsight_devices.json" : "netsight_port.json"
        [200, {}, Rails.root.join("test/services", fixture).read]
      end
    end
  end

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
      entity = device.dig("entityData", "port") || {}
      data = device.dig("deviceData", "port") || {}

      new(sys_name: device["sysName"],
          if_name: entity["ifName"],
          oper_status: entity["formattedOperStatus"],
          speed: entity["formattedSpeed"],
          description: entity["ifAlias"].presence,
          lag_master_if_index: (entity["lagMasterIndex"] if entity["isLagContributor"]),
          tagged: data["tagged"].to_a.sort,
          untagged: data["untagged"].to_a.sort)
    end

    def self.normalize_vlans(vlans)
      vlans.to_s.downcase.split(",").map(&:strip).compact_blank.sort
    end

    def dcim_vlans
      (untagged.map { |vid| "u#{vid}" } + tagged.map { |vid| "t#{vid}" }).join(", ")
    end

    def matches_dcim?(vlans)
      self.class.normalize_vlans(vlans) == self.class.normalize_vlans(dcim_vlans)
    end

    def default_vlan_only?
      tagged.empty? && untagged == [DEFAULT_VLAN]
    end

    def lag_member?
      lag_master_if_index.present?
    end

    def lag_master_name
      "#{lag_master_if_index / PORTS_PER_SLOT}:#{lag_master_if_index % PORTS_PER_SLOT}" if lag_member?
    end
  end
end
