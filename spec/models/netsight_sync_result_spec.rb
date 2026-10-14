# frozen_string_literal: true

require "rails_helper"

RSpec.describe NetsightSyncResult do
  let(:request) { ExternalAppRequest.create!(user: users(:admin), external_app_name: "netsight") }
  let(:port) { Port.create!(position: 2, attachable: cards(:three), vlans: "u300") }
  let(:peer_port) { Port.create!(position: 1, attachable: cards(:seven), vlans: "u300") }
  let(:result) do
    described_class.create!(external_app_request: request, server: port.server, port:, kind: :vlan, status: :differs,
                            dcim_value: "u300", netsight_value: "u201, t1192")
  end

  before do
    cable = Cable.create!(name: "C1")
    Connection.create!(cable:, port:)
    Connection.create!(cable:, port: peer_port)
  end

  describe "validations" do
    it "rejects a status of another kind" do
      expect(described_class.new(kind: :switch, status: :differs).tap(&:validate).errors).to include(:status)
    end
  end

  describe "#apply!" do
    it "writes the Netsight VLANs on both ends of the cable" do
      result.apply!

      expect([port.reload.vlans, peer_port.reload.vlans]).to eq(["u201, t1192", "u201, t1192"])
    end

    it { expect { result.apply! }.to change { result.reload.applied_at }.from(nil) }
    it { expect { result.apply! }.to change { port.changelog_entries.count }.by(1) }

    it "skips a port changed in DCIM since the synchronization", :aggregate_failures do
      port.update!(vlans: "u400")

      expect(result.apply!).to be(false)
      expect(port.reload.vlans).to eq("u400")
    end

    it "skips a result already applied" do
      result.update!(applied_at: 1.hour.ago)

      expect(result.apply!).to be(false)
    end

    it "fills in the serial number of a switch" do
      switch_result = described_class.create!(external_app_request: request, server: servers(:one), kind: :switch,
                                              status: :serial_to_complete, dcim_value: servers(:one).numero,
                                              netsight_value: "0001N-00010")

      expect { switch_result.apply! }.to change { servers(:one).reload.numero }.to("0001N-00010")
    end

    it "refuses a serial number already used by another server" do
      switch_result = described_class.create!(external_app_request: request, server: servers(:one), kind: :switch,
                                              status: :serial_to_complete, dcim_value: servers(:one).numero,
                                              netsight_value: servers(:two).numero)

      expect(switch_result.apply!).to be(false)
    end

    it "only applies VLAN differences" do
      result.update!(status: :free_text)

      expect(result.apply!).to be(false)
    end
  end
end
