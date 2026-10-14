# frozen_string_literal: true

module Netsight
  class Client
    # Sample answers used outside production, read from test/services
    module Stubs
      def self.build
        Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get(%r{\A/?\z}) { |env| [200, {}, answer(env.params["query"].to_s)] }
        end
      end

      def self.answer(query)
        if query.include?("deviceTopology") then serials(query)
        elsif query.include?("devices") then fixture("netsight_devices.json")
        elsif query.exclude?("allPorts") then fixture("netsight_port.json")
        elsif query.include?(DEMO_IP) then fixture("netsight_device_snapshot.json")
        else '{"data":{"network":{"device":null}}}'
        end
      end

      # Answers each "dN: device(ip: ...)" alias with the sample device of that IP
      def self.serials(query)
        devices = JSON.parse(fixture("netsight_serials.json"))
        network = query.scan(/(d\d+): device\(ip: "([^"]+)"\)/).to_h { |name, ip| [name, devices[ip]] }

        { data: { network: } }.to_json
      end

      def self.fixture(name)
        Rails.root.join("test/services", name).read
      end
    end
  end
end
