# frozen_string_literal: true

require "rails_helper"

RSpec.describe NetsightPortLocator, type: :service do
  subject(:result) { described_class.new(client:).call(port) }

  let(:switch) { servers(:one) }
  let(:client) { instance_double(NetsightClient, demo?: false) }
  let(:port) { ports(:four) }

  before do
    allow(client).to receive(:device_ip).and_return(nil)
    allow(client).to receive(:device_ip).with("SXT_TEST").and_return("10.0.0.1")
  end

  context "with a port on a stacked switch" do
    before { switch.update!(name: "SXT_TEST:Slot3") }

    it do
      expect(result).to have_attributes(status: :found, port:, sys_name: "SXT_TEST", ip: "10.0.0.1",
                                        if_index: 3006)
    end
  end

  context "with a port on a standalone switch" do
    before { switch.update!(name: "SXT_TEST") }

    it { expect(result).to have_attributes(status: :found, if_index: 1006) }
  end

  context "with a switch name carrying extra text" do
    before do
      allow(client).to receive(:device_ip).with("sxt_test").and_return("10.0.0.1")
      switch.update!(name: " sxt_test:slot3 (A RETIRER)")
    end

    it { expect(result).to have_attributes(status: :found, sys_name: "sxt_test", if_index: 3006) }
  end

  context "with a server port cabled to a switch" do
    let(:server_card) { cards(:four) }
    let(:switch_port) { Port.create!(position: 3, attachable: cards(:three)) }
    let(:port) { Port.create!(position: 3, attachable: server_card) }

    before do
      switch.update!(name: "SXT_TEST:Slot1")
      cable = Cable.create!(name: "A03")
      Connection.create!(cable:, port: switch_port)
      Connection.create!(cable:, port:)
    end

    it { expect(result).to have_attributes(status: :found, port: switch_port, if_index: 1003) }
  end

  context "with a port on an uplink card of the switch" do
    let(:port) { ports(:three) }

    before { switch.update!(name: "SXT_TEST:Slot1") }

    it { expect(result).to have_attributes(status: :unsupported_card, port:) }
  end

  context "with a port on a smaller card when showing sample data" do
    let(:client) { instance_double(NetsightClient, demo?: true) }
    let(:port) { ports(:three) }

    before { switch.update!(name: "SXT_TEST:Slot1") }

    it { expect(result).to have_attributes(status: :found, if_index: 1003) }
  end

  context "when no server around the port is known to Netsight" do
    it { expect(result).to have_attributes(status: :no_switch, port: nil) }
    it { expect(result).not_to be_found }
  end

  context "with a power port" do
    let(:port) { Port.create!(position: 1, attachable: cards(:nine)) }

    before { servers(:accesible_to_readers).update!(name: "SXT_TEST") }

    it { expect(result.status).to eq(:no_switch) }
  end
end
