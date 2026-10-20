# frozen_string_literal: true

require "rails_helper"

RSpec.describe Netsight::Client, type: :service do
  let(:client) { described_class.new }

  describe "#device_ip" do
    it { expect(client.device_ip("SW_TEST01")).to eq("192.0.2.63") }
    it { expect(client.device_ip("sw_test01")).to eq("192.0.2.63") }
    it { expect(client.device_ip("SW_ALIAS05")).to eq("192.0.2.141") }
    it { expect(client.device_ip("UNKNOWN")).to be_nil }
    it { expect(client.device_ip("")).to be_nil }

    it "prefers a sysName over another device's nickname" do
      expect(client.device_ip("SW_TEST04")).to eq("192.0.2.40")
    end

    context "when showing sample data in development" do
      before { allow(described_class).to receive(:demo?).and_return(true) }

      it { expect(client.device_ip("ServerName1")).to eq(described_class::DEMO_IP) }
      it { expect(client.device_ip("")).to be_nil }
    end
  end

  describe ".demo?" do
    it { expect(described_class).not_to be_demo }

    it "is on in development without a real Netsight" do
      allow(Rails.env).to receive(:development?).and_return(true)

      expect(described_class).to be_demo
    end

    it "is off in development with a real Netsight" do
      allow(Rails.env).to receive(:development?).and_return(true)
      allow(NetsightApiConfig).to receive(:local_server).and_return(true)

      expect(described_class).not_to be_demo
    end
  end

  describe "#port" do
    subject(:port) { client.port(ip: "192.0.2.63", if_index: 2001) }

    it "merges the entity and the device data of the port" do
      expect(port).to have_attributes(sys_name: "SW_TEST01", if_name: "2:1", oper_status: "Up", speed: "1 Gbps",
                                      description: "STORAGE-1 CTRL", tagged: [1192, 1194], untagged: [],
                                      lag_master_if_index: nil)
    end

    it "reads when Netsight last scanned the switch" do
      expect(port.scanned_at).to eq(Time.zone.at(1_792_502_100))
    end

    it "rejects an IP that is not one" do
      expect { client.port(ip: '1.2.3.4") { x', if_index: 1001) }.to raise_error(ArgumentError)
    end

    context "when the device or the port is unknown" do
      before do
        allow(client.connection).to receive(:get)
          .and_return(instance_double(Faraday::Response, body: '{"data":{"network":{"device":null}}}'))
      end

      it { expect(port).to be_nil }
    end

    context "when Netsight returns GraphQL errors" do
      before do
        allow(client.connection).to receive(:get)
          .and_return(instance_double(Faraday::Response, body: '{"errors":[{"message":"bad field"}]}'))
      end

      it { expect { port }.to raise_error(Netsight::Client::Error, "bad field") }
    end
  end

  describe "#sys_name_for" do
    it { expect(client.sys_name_for("192.0.2.60")).to eq("SW_TEST02") }
    it { expect(client.sys_name_for("10.0.0.1")).to be_nil }
  end

  describe "#known_device_ip" do
    before { allow(described_class).to receive(:demo?).and_return(true) }

    it "ignores the sample data" do
      expect(client.known_device_ip("ServerName1")).to be_nil
    end
  end

  describe "#device_snapshot" do
    subject(:snapshot) { client.device_snapshot(ip: "192.0.2.63") }

    it "indexes the ports by ifName" do
      expect(snapshot.ports.keys).to eq(["1:1", "1:2", "1:51", "1:52", "2:1"])
    end

    it "merges the VLANs of each port" do
      expect(snapshot.ports["1:1"]).to have_attributes(sys_name: "SW_TEST01", untagged: [201], tagged: [])
    end

    it "orients the links from the device and drops duplicates" do
      expect(snapshot.links.map { |link| [link.if_name, link.peer_ip, link.peer_if_name] })
        .to eq([["1:52", "192.0.2.60", "1:3"], ["1:51", "192.0.2.73", "1:51"]])
    end

    it { expect { client.device_snapshot(ip: "x } }") }.to raise_error(ArgumentError) }
  end

  describe Netsight::Client::Port do
    let(:attributes) do
      { sys_name: "SW_TEST01", if_name: "1:1", oper_status: "Up", speed: "1 Gbps", description: nil,
        lag_master_if_index: nil, tagged: [1192, 1194], untagged: [201] }
    end
    let(:port) { described_class.new(attributes) }

    describe "#dcim_vlans" do
      it { expect(port.dcim_vlans).to eq("u201, t1192, t1194") }
    end

    describe "#matches_dcim?" do
      it { expect(port.matches_dcim?("u201, t1192, t1194")).to be(true) }
      it { expect(port.matches_dcim?("T1194,t1192 , U201")).to be(true) }
      it { expect(port.matches_dcim?("u201, t1192")).to be(false) }
      it { expect(port.matches_dcim?(nil)).to be(false) }
      it { expect(port.matches_dcim?("u201 t1192 t1194")).to be(true) }
    end

    describe ".scan_time" do
      it { expect(described_class.scan_time(1_792_502_100_000)).to eq(Time.zone.at(1_792_502_100)) }
      it { expect(described_class.scan_time(nil)).to be_nil }
      it { expect(described_class.scan_time(0)).to be_nil }
    end

    describe ".vlan_list?" do
      it { expect(described_class.vlan_list?("u201, T1192")).to be(true) }
      it { expect(described_class.vlan_list?(nil)).to be(true) }
      it { expect(described_class.vlan_list?("All")).to be(false) }
      it { expect(described_class.vlan_list?("f1 port5")).to be(false) }
    end

    describe "#dcim_vlans on a trunk" do
      it "omits the switch default VLAN left untagged" do
        expect(described_class.new(attributes.merge(untagged: [1])).dcim_vlans).to eq("t1192, t1194")
      end
    end

    describe "#no_vlan?" do
      it { expect(port).not_to be_no_vlan }
      it { expect(described_class.new(attributes.merge(tagged: [], untagged: [])).no_vlan?).to be(true) }
    end

    describe "#default_vlan_only?" do
      it { expect(port.default_vlan_only?).to be(false) }
      it { expect(described_class.new(attributes.merge(tagged: [], untagged: [1])).default_vlan_only?).to be(true) }
    end

    describe "#lag_master_name" do
      it { expect(port.lag_master_name).to be_nil }
      it { expect(described_class.new(attributes.merge(lag_master_if_index: 3057)).lag_master_name).to eq("3:57") }
    end
  end
end
