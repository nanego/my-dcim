# frozen_string_literal: true

require "rails_helper"

RSpec.describe NetsightClient, type: :service do
  let(:client) { described_class.new }

  describe "#device_ip" do
    it { expect(client.device_ip("SXT_SEQ63a")).to eq("10.128.5.63") }
    it { expect(client.device_ip("sxt_seq63a")).to eq("10.128.5.63") }
    it { expect(client.device_ip("SXT_APS00o")).to eq("10.128.5.141") }
    it { expect(client.device_ip("UNKNOWN")).to be_nil }
    it { expect(client.device_ip("")).to be_nil }

    it "prefers a sysName over another device's nickname" do
      expect(client.device_ip("SXT_SEQ40c")).to eq("10.128.5.40")
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
    subject(:port) { client.port(ip: "10.128.5.63", if_index: 2001) }

    it "merges the entity and the device data of the port" do
      expect(port).to have_attributes(sys_name: "SXT_SEQ63a", if_name: "2:1", oper_status: "Up", speed: "1 Gbps",
                                      description: "DSP-NETAPP-1 CTRL", tagged: [1192, 1194], untagged: [],
                                      lag_master_if_index: nil)
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

      it { expect { port }.to raise_error(NetsightClient::Error, "bad field") }
    end
  end

  describe NetsightClient::Port do
    let(:attributes) do
      { sys_name: "SXT_SEQ63a", if_name: "1:1", oper_status: "Up", speed: "1 Gbps", description: nil,
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
