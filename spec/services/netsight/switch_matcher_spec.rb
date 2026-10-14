# frozen_string_literal: true

require "rails_helper"

RSpec.describe Netsight::SwitchMatcher, type: :service do
  subject(:match) { described_class.new(client).call(server) }

  let(:client) { instance_double(Netsight::Client, serial_index: { "0001N-00014" => ["10.0.0.1", 3] }) }
  let(:server) { servers(:one) }

  before do
    allow(client).to receive(:known_device_ip).and_return(nil)
    allow(client).to receive(:known_device_ip).with("SW_A").and_return("10.0.0.1")
    allow(client).to receive(:known_device_ip).with("SW_B").and_return("10.0.0.2")
  end

  context "with a serial number known to Netsight" do
    before { server.update!(name: "SW_A:Slot3", numero: "0001n-00014") }

    it { expect(match).to have_attributes(ip: "10.0.0.1", slot: 3, issue: nil, netsight_serial: "0001N-00014") }
  end

  context "when the serial number wins over a misleading name" do
    before { server.update!(name: "SW_B:Slot1", numero: "0001N-00014") }

    it { expect(match).to have_attributes(ip: "10.0.0.1", slot: 3, issue: :name_serial_mismatch) }
  end

  context "with a placeholder serial number" do
    before { server.update!(name: "SW_A:Slot3", numero: "sw_a-slot3") }

    it { expect(match).to have_attributes(ip: "10.0.0.1", slot: 3, issue: :serial_to_complete) }
  end

  context "with an Extreme serial number unknown to Netsight" do
    before { server.update!(name: "SW_B", numero: "0009N-00001") }

    it { expect(match).to have_attributes(ip: "10.0.0.2", slot: 1, issue: :serial_not_in_netsight) }
  end

  context "with a server unknown to Netsight" do
    before { server.update!(name: "ServerName1") }

    it { expect(match).to be_nil }
  end
end
