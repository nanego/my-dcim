# frozen_string_literal: true

require "rails_helper"

RSpec.describe Netsight::Sync, type: :service do
  subject(:sync) { described_class.new(request, client:).call }

  let(:request) { ExternalAppRequest.create!(user: users(:admin), external_app_name: "netsight") }
  let(:client) { instance_double(Netsight::Client) }
  let(:netsight_ports) { {} }
  let(:links) { [] }
  let(:serial_index) { {} }
  let(:port) { Port.create!(position: 2, attachable: cards(:three)) } # SW_A 1:7, after Card1 and Card2

  def netsight_port(untagged: [], tagged: [])
    Netsight::Client::Port.new(sys_name: "SW_A", if_name: nil, oper_status: "Up", speed: nil, description: nil,
                               lag_master_if_index: nil, tagged:, untagged:)
  end

  def cable(port_a, port_b)
    cable = Cable.create!(name: "C#{port_a.id}")
    Connection.create!(cable:, port: port_a)
    Connection.create!(cable:, port: port_b)
  end

  def results(kind) = NetsightSyncResult.where(kind:, port:)

  before do
    servers(:one).update!(name: "SW_A:Slot1")
    servers(:four).update!(name: "SW_B")
    allow(client).to receive_messages(known_device_ip: nil, device_snapshot: nil, sys_name_for: nil, serial_index:)
    allow(client).to receive(:known_device_ip).with("SW_A").and_return("10.0.0.1")
    allow(client).to receive(:known_device_ip).with("SW_B").and_return("10.0.0.2")
    allow(client).to receive(:sys_name_for).with("10.0.0.2").and_return("SW_B")
    allow(client).to receive(:device_snapshot).with(ip: "10.0.0.1")
      .and_return(Netsight::Client::DeviceSnapshot.new(ports: netsight_ports, links:))
  end

  describe "VLAN comparison" do
    context "when the VLANs differ" do
      let(:netsight_ports) { { "1:7" => netsight_port(untagged: [201]) } }

      before { port.update!(vlans: "u300") }

      it do
        sync
        expect(results(:vlan).sole).to have_attributes(status: "differs", port:, if_name: "1:7",
                                                       dcim_value: "u300", netsight_value: "u201")
      end
    end

    context "when the VLANs match" do
      let(:netsight_ports) { { "1:7" => netsight_port(untagged: [201]) } }

      before { port.update!(vlans: "U201") }

      it { expect { sync }.not_to change(results(:vlan), :count) }
    end

    context "when the switch port only has the default VLAN" do
      let(:netsight_ports) { { "1:7" => netsight_port(untagged: [1]) } }

      before { port.update!(vlans: "u201") }

      it { expect { sync }.to change { results(:vlan).status_default_vlan_only.count }.by(1) }
    end

    context "when Netsight has no VLAN on the port" do
      let(:netsight_ports) { { "1:7" => netsight_port } }

      before { port.update!(vlans: "u201") }

      it { expect { sync }.to change { results(:vlan).status_no_netsight_vlans.count }.by(1) }
    end

    context "when DCIM holds free text" do
      let(:netsight_ports) { { "1:7" => netsight_port(tagged: [201, 202]) } }

      before { port.update!(vlans: "All") }

      it { expect { sync }.to change { results(:vlan).status_free_text.count }.by(1) }
    end

    context "when Netsight does not know the port" do
      before { port.update!(vlans: "u201") }

      it { expect { sync }.to change { results(:vlan).status_unknown_port.count }.by(1) }
    end

    context "with a port unused in DCIM" do
      before { port.update!(vlans: nil) }

      it { expect { sync }.not_to change(results(:vlan), :count) }
    end
  end

  describe "link comparison" do
    let(:links) do
      [Netsight::Client::Link.new(if_name: "1:7", peer_ip: "10.0.0.2", peer_if_name: "1:1", protocol: "EDP",
                                  type: "Interswitch", status: "up")]
    end
    let(:peer_port) { Port.create!(position: 1, attachable: cards(:four)) } # SW_B 1:1

    context "when DCIM has the same cable" do
      before { cable(port, peer_port) }

      it do
        sync
        expect(results(:link).sole).to have_attributes(status: "matches", port:, if_name: "1:7",
                                                       netsight_peer: "SW_B 1:1")
      end
    end

    context "when DCIM cables the port elsewhere" do
      before do
        peer_port
        cable(port, Port.create!(position: 1, attachable: cards(:seven)))
      end

      it { expect { sync }.to change { results(:link).status_differs.count }.by(1) }
    end

    context "when the DCIM path stops on a patch panel" do
      before do
        peer_port
        cards(:seven).server.modele.category.update!(name: "Patch Panel")
        cable(port, Port.create!(position: 1, attachable: cards(:seven)))
      end

      it { expect { sync }.to change { results(:link).status_broken_path.count }.by(1) }
    end

    context "when DCIM has no cable on the port" do
      it { expect { sync }.to change { results(:link).status_not_cabled_in_dcim.count }.by(1) }
    end
  end

  describe "identity checks" do
    let(:serial_index) { { "0001N-00010" => ["10.0.0.1", 1] } }

    before { allow(client).to receive(:sys_name_for).with("10.0.0.1").and_return("SW_A") }

    it "proposes the Netsight serial number of a switch found by name" do
      sync

      expect(NetsightSyncResult.kind_switch.find_by(server: servers(:one)))
        .to have_attributes(status: "serial_to_complete", netsight_value: "0001N-00010", netsight_peer: "SW_A slot 1")
    end

    it "reports a serial number that points to another switch" do
      servers(:four).update!(numero: "0001N-00010")
      servers(:one).update!(numero: "0000A-00000")

      sync

      expect(NetsightSyncResult.kind_switch.find_by(server: servers(:four)).status).to eq("name_serial_mismatch")
    end
  end

  it "reports the servers of a switch model unknown to Netsight" do
    sync

    expect(NetsightSyncResult.kind_switch.map(&:server)).to include(servers(:two))
  end

  context "when Netsight fails on a switch" do
    let!(:previous_vlan) do
      previous = ExternalAppRequest.create!(user: users(:admin), external_app_name: "netsight", status: :completed)
      NetsightSyncResult.create!(external_app_request: previous, server: servers(:one), port:, kind: :vlan,
                                 status: :differs, dcim_value: "u300", netsight_value: "u201")
    end

    before { allow(client).to receive(:device_snapshot).with(ip: "10.0.0.1").and_raise(Netsight::Client::Error, "boom") }

    it { expect { sync }.to change { request.reload.progress }.to(100) }

    it "reports the switch as unreachable" do
      sync

      expect(NetsightSyncResult.kind_switch.find_by(server: servers(:one)))
        .to have_attributes(status: "netsight_unreachable", netsight_value: "boom")
    end

    it "keeps its previous results" do
      sync

      expect(NetsightSyncResult.exists?(previous_vlan.id)).to be(true)
    end
  end

  it "replaces the results of the previous synchronization" do
    previous = ExternalAppRequest.create!(user: users(:admin), external_app_name: "netsight", status: :completed)
    NetsightSyncResult.create!(external_app_request: previous, server: servers(:one), kind: :switch, status: :not_in_netsight)

    sync

    expect(NetsightSyncResult.where(external_app_request: previous)).to be_empty
  end
end
