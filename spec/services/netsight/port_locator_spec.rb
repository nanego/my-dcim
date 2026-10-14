# frozen_string_literal: true

require "rails_helper"

RSpec.describe Netsight::PortLocator, type: :service do
  subject(:result) { described_class.new(client:).call(port) }

  let(:switch) { servers(:one) }
  let(:client) { instance_double(Netsight::Client) }
  let(:port) { ports(:four) }

  before do
    allow(client).to receive(:device_ip).and_return(nil)
    allow(client).to receive(:device_ip).with("SW_TEST").and_return("10.0.0.1")
  end

  context "with a port on a stacked switch" do
    before { switch.update!(name: "SW_TEST:Slot3") }

    it do
      expect(result).to have_attributes(status: :found, port:, sys_name: "SW_TEST", ip: "10.0.0.1",
                                        if_index: 3011, if_name: "3:11")
    end
  end

  context "with a port on a standalone switch" do
    before { switch.update!(name: "SW_TEST") }

    it { expect(result).to have_attributes(status: :found, if_index: 1011, if_name: "1:11") }
  end

  context "with a switch name carrying extra text" do
    before do
      allow(client).to receive(:device_ip).with("sw_test").and_return("10.0.0.1")
      switch.update!(name: " sw_test:slot3 (A RETIRER)")
    end

    it { expect(result).to have_attributes(status: :found, sys_name: "sw_test", if_index: 3011) }
  end

  context "with a server port cabled to a switch" do
    let(:server_card) { cards(:four) }
    let(:switch_port) { Port.create!(position: 3, attachable: cards(:three)) }
    let(:port) { Port.create!(position: 3, attachable: server_card) }

    before do
      switch.update!(name: "SW_TEST:Slot1")
      cable = Cable.create!(name: "A03")
      Connection.create!(cable:, port: switch_port)
      Connection.create!(cable:, port:)
    end

    it { expect(result).to have_attributes(status: :found, port: switch_port, if_index: 1008) }
  end

  context "with a port on a card that follows another one" do
    let(:port) { ports(:three) }

    before { switch.update!(name: "SW_TEST:Slot1") }

    it { expect(result).to have_attributes(status: :found, port:, if_index: 1006, if_name: "1:6") }
  end

  context "when no server around the port is known to Netsight" do
    it { expect(result).to have_attributes(status: :no_switch, port: nil) }
    it { expect(result).not_to be_found }
  end

  context "with a power port" do
    let(:port) { Port.create!(position: 1, attachable: cards(:nine)) }

    before { servers(:accesible_to_readers).update!(name: "SW_TEST") }

    it { expect(result.status).to eq(:no_switch) }
  end

  describe ".numbered_ports" do
    subject(:numbered_ports) { described_class.numbered_ports(switch) }

    it "numbers the ports across the data cards in composant order" do
      expect(numbered_ports.slice(1, 6, 11)).to eq(1 => ports(:one), 6 => ports(:three), 11 => ports(:four))
    end

    it "starts a card at its first position when set" do
      cards(:three).update!(first_position: 20)

      expect(numbered_ports.slice(1, 25)).to eq(1 => ports(:one), 25 => ports(:four))
    end

    it "skips the fan cards" do
      fan_type = CardType.create!(name: "1FAN", port_quantity: 1, port_type: PortType.create!(name: "FAN"))
      Card.create!(server: switch, composant: composants(:one), card_type: fan_type)

      expect(numbered_ports.slice(1, 11)).to eq(1 => ports(:one), 11 => ports(:four))
    end
  end

  describe ".parse_name" do
    it { expect(described_class.parse_name("SW_TEST01:Slot2")).to eq(["SW_TEST01", 2]) }
    it { expect(described_class.parse_name("SW_TEST02")).to eq(["SW_TEST02", 1]) }
    it { expect(described_class.parse_name("")).to be_nil }
  end
end
