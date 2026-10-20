# frozen_string_literal: true

module Netsight
  require "faraday"
  require "json"

  class Client
    PROXY_URL = Rails.application.credentials.proxy_url

    DEVICES_CACHE_KEY = "netsight/devices/list"
    DEVICES_CACHE_TTL = 1.hour
    SERIALS_CACHE_KEY = "netsight/serials"
    SERIALS_BATCH_SIZE = 25
    DEVICES_QUERY = "{ network { devices { ip sysName nickName } } }"
    PORT_FIELDS = "ifName formattedOperStatus formattedSpeed ifAlias isLagContributor lagMasterIndex vlanList"
    TIMEOUTS = { open_timeout: 3, timeout: 10 }.freeze
    DEMO_IP = "192.0.2.63"

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
                      Faraday.new { |b| b.adapter(:test, Stubs.build) }
                    end
    end

    def device_ip(name)
      return DEMO_IP if demo? && name.present?

      known_device_ip(name)
    end

    def known_device_ip(name)
      devices_index[name.to_s.downcase]
    end

    def sys_name_for(ip)
      @sys_names ||= devices.to_h { |device| [device["ip"], device["sysName"]] }
      @sys_names[ip]
    end

    delegate :demo?, to: :class

    def port(ip:, if_index:)
      validate_ip!(ip)

      device = graphql(<<~GRAPHQL).dig("network", "device")
        { network { device(ip: "#{ip}") { sysName
          entityData { lastFullScan vlanSupported port(ifIndex: #{Integer(if_index)}) { #{PORT_FIELDS} } }
        } } }
      GRAPHQL

      Port.from_api(device) if device&.dig("entityData", "port")
    end

    # Serial number => [device IP, slot], one entry per stack member
    def serial_index
      @serial_index ||= Rails.cache.fetch(SERIALS_CACHE_KEY, expires_in: DEVICES_CACHE_TTL) do
        devices.pluck("ip").compact.uniq.each_slice(SERIALS_BATCH_SIZE).with_object({}) do |ips, index|
          ips.each { |ip| validate_ip!(ip) }
          graphql(DeviceSerials.query(ips)).fetch("network").each_value do |device|
            index.merge!(DeviceSerials.from_api(device)) if device
          end
        end
      end
    end

    # Every port and inter-switch link of a device (a whole stack) in one query
    def device_snapshot(ip:)
      validate_ip!(ip)

      device = graphql(<<~GRAPHQL).dig("network", "device") or return
        { network { device(ip: "#{ip}") { sysName
          entityData { vlanSupported allPorts { #{PORT_FIELDS} } }
          links { ifName1 deviceIp1 ifName2 deviceIp2 discoveryProto formattedType status }
        } } }
      GRAPHQL

      DeviceSnapshot.from_api(device, ip:)
    end

    private

    def validate_ip!(ip)
      raise ArgumentError, "invalid device IP: #{ip.inspect}" unless ip.to_s.match?(/\A[\h.:]+\z/)
    end

    def graphql(query)
      body = JSON.parse(connection.get("", query:).body)
      raise Error, body["errors"].pluck("message").join(", ") if body["errors"].present?

      body.fetch("data")
    end

    def devices
      @devices ||= Rails.cache.fetch(DEVICES_CACHE_KEY, expires_in: DEVICES_CACHE_TTL) do
        graphql(DEVICES_QUERY).dig("network", "devices").to_a
      end
    end

    # Nicknames go in first so that a sysName wins over another device's nickname
    def devices_index
      @devices_index ||= %w[nickName sysName].each_with_object({}) do |key, index|
        devices.each { |device| index[device[key].downcase] = device["ip"] if device[key].present? }
      end
    end
  end
end
