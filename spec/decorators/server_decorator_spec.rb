# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServerDecorator, type: :decorator do
  let(:server) { servers(:one) }
  let(:decorated_server) { server.decorated }
  let(:user) { users(:admin) }

  describe ".options_for_select" do
    it do
      expect(described_class.options_for_select(user))
        .to contain_exactly(
          ["ServerName1", 1], ["ServerName2", 2], ["ServerName3", 740_841_338], ["ServerName4", 4],
          ["ServerName5", 5], ["ServerName6", 6], ["ReadableServer", 8],
        )
    end
  end

  describe ".rooms_options_for_select" do
    it do
      expect(described_class.rooms_options_for_select(user))
        .to contain_exactly(
          ["Site 1 - S1", 1], ["Site 1 - S2", 2], ["Site 1 - S5", 5], ["Site 2 - S3", 3], ["Site 2 - S4", 4],
          ["Site 3 - S6", 6],
        )
    end
  end

  describe ".islets_options_for_select" do
    it do
      expect(described_class.islets_options_for_select(user))
        .to contain_exactly(
          ["Ilot Islet1 S1", 1], ["Ilot Islet2 S1", 2], ["Ilot Islet3 S1", 3], ["Ilot Islet4 S6", 4],
          ["Ilot Islet5 S1", 5],
        )
    end
  end

  describe ".bays_options_for_select" do
    it do
      expect(described_class.bays_options_for_select(user))
        .to contain_exactly(
          ["Baie vide", 3], ["Baie vide", 5], ["MyFrame1 / MyFrame2", 1], ["MyFrame3 / MyFrame4", 2], ["MyFrame5", 4],
        )
    end
  end

  describe ".frames_options_for_select" do
    it do
      expect(described_class.frames_options_for_select(user))
        .to contain_exactly(["MyFrame1", 1], ["MyFrame2", 2], ["MyFrame3", 3], ["MyFrame4", 4], ["MyFrame5", 5])
    end
  end

  describe ".domains_options_for_select" do
    it do
      expect(described_class.domains_options_for_select(user))
        .to contain_exactly(["Empty domain", 4], ["Empty domain 2", 5], ["Stock", 2], ["Switch", 1], ["Three", 3])
    end
  end

  describe ".manufacturers_options_for_select" do
    it do
      expect(described_class.manufacturers_options_for_select)
        .to contain_exactly(["Fourth", 4], ["Third", 3], ["fortinet", 1], ["juniper", 2])
    end
  end

  describe "#glpi_equipment" do
    subject(:equipment) { decorated_server.glpi_equipment(with_client: client) }

    let(:client) { GlpiClient.new }

    before do
      allow(client).to receive_messages(
        computer: "computer",
        network_equipment: "network_equipment",
      )
    end

    context "without client" do
      let(:client) { decorated_server.send(:glpi_client) }

      it { expect(equipment).to eq("computer") }
    end

    context "with glpi_sync_type none" do
      let(:server) { servers(:hub_network1) }

      it { expect(equipment).to be_nil }
    end

    context "with external app record" do
      let(:server) { servers(:two) }

      before do
        allow(decorated_server).to receive(:glpi_equipment_id).and_return("")
        external_app_records(:two)
      end

      it { expect(equipment).to eq("computer") }
    end

    context "when glpi_sync_type is network_equipment" do
      let(:server) do
        servers(:one).tap do |server|
          server.modele.category.glpi_sync_type = :network_equipment
        end
      end

      it { expect(equipment).to eq("network_equipment") }
    end
  end

  describe "#glpi_equipment_id" do
    subject(:id) { decorated_server.glpi_equipment_id }

    let(:client) { GlpiClient.new }

    before do
      allow(client).to receive_messages(computer_glpi_id: "computer")
      decorated_server.instance_variable_set(:@glpi_client, client)
    end

    it { expect(id).to eq("computer") }
  end

  describe "#network_types_to_human" do
    subject(:network_types_sentence) { decorated_server.network_types_to_human }

    context "when server has no network type" do
      it { is_expected.to eq("Non (par défaut)") }
    end

    context "when server has one network type" do
      before { server.network_types = %w[gbe] }

      it { is_expected.to eq("Backbone Gbps") }
    end

    context "when server has many network types" do
      before { server.network_types = %w[10gbe fiber] }

      it { is_expected.to eq("Backbone 10Gbps, Backbone Fibre") }
    end
  end

  describe "#full_name" do
    it { expect(decorated_server.full_name).to eq("MyString ServerName1") }

    context "when server has no model" do
      before { server.modele = nil }

      it { expect(decorated_server.full_name).to eq("ServerName1") }
    end
  end

  describe "#full_location" do
    it { expect(decorated_server.full_location).to eq("Site 1 - Ilot Islet1 S1") }
  end

  describe "#in_frame_location" do
    it { expect(decorated_server.in_frame_location).to eq("MyFrame1 - U39") }

    context "without position" do
      before { server.position = nil }

      it { expect(decorated_server.in_frame_location).to eq("MyFrame1 - U?") }
    end
  end
end
