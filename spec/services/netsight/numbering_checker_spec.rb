# frozen_string_literal: true

require "rails_helper"

RSpec.describe Netsight::NumberingChecker, type: :service do
  subject(:findings) { described_class.new(snapshot).call(2, numbered_ports) }

  let(:card) { instance_double(Card) }
  let(:vlans_collected) { true }
  let(:snapshot) { Netsight::Client::DeviceSnapshot.new(ports: netsight_ports, links: [], vlans_collected:) }
  # DCIM ports 1 to 10, each with its own VLAN
  let(:numbered_ports) do
    (1..10).index_with { |number| instance_double(Port, card:, vlans: "u#{100 + number}", connection: nil) }
  end

  def build_ports(shift: 0, oper_status: "Up")
    (1..20).to_h do |number|
      port = Netsight::Client::Port.new(sys_name: "SW", if_name: "2:#{number}", oper_status:, speed: nil, description: nil,
                                        lag_master_if_index: nil, tagged: [], untagged: [100 + number - shift])
      [port.if_name, port]
    end
  end

  context "when DCIM and Netsight agree" do
    let(:netsight_ports) { build_ports }

    it { expect(findings).to be_empty }
  end

  context "when Netsight numbers the ports of the card further" do
    let(:netsight_ports) { build_ports(shift: 4) }

    it do
      expect(findings.sole).to have_attributes(status: :shifted, first_port: numbered_ports[1], if_name: "2:1",
                                               expected_if_name: "2:5", evidence: 10, matches: 0, shifted_matches: 10)
    end
  end

  context "when a few ports only agree once shifted" do
    let(:netsight_ports) { build_ports(shift: 50).merge(build_ports(shift: 1).slice("2:2", "2:3", "2:4")) }

    it { expect(findings).to be_empty }
  end

  context "when Netsight doesn't know most ports of the card" do
    let(:netsight_ports) { build_ports.slice("2:1", "2:2") }

    it { expect(findings.sole).to have_attributes(status: :unknown_ports, expected_if_name: nil, matches: 2) }
  end

  context "when Netsight does not poll the VLANs of the switch" do
    let(:vlans_collected) { false }
    # Ports 1 to 6 are cabled in DCIM, Netsight sees ports 5 to 10 up
    let(:numbered_ports) do
      (1..10).index_with do |number|
        instance_double(Port, card:, vlans: nil, connection: (instance_double(Connection) if number <= 6))
      end
    end
    let(:netsight_ports) do
      build_ports(oper_status: "Down").merge(build_ports.slice(*(5..10).map { "2:#{it}" }))
    end

    it "compares the cabled ports with the ports up" do
      expect(findings.sole).to have_attributes(status: :shifted, expected_if_name: "2:5", evidence: 6, matches: 2,
                                               shifted_matches: 6)
    end
  end

  context "with a card without any port in use" do
    let(:numbered_ports) { { 1 => instance_double(Port, card:, vlans: nil, connection: nil) } }
    let(:netsight_ports) { {} }

    it { expect(findings).to be_empty }
  end
end
