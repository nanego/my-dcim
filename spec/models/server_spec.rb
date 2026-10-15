# frozen_string_literal: true

require "rails_helper"

RSpec.describe Server do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:server) do
    described_class.new(name: "ACTARUS", frame: Frame.new, modele: Modele.new, numero: "1245")
  end

  describe "associations" do
    it { is_expected.to belong_to(:frame) }
    it { is_expected.to belong_to(:manager).optional(true) }
    it { is_expected.to belong_to(:domain).optional(true) }
    it { is_expected.to belong_to(:cluster).optional(true) }
    it { is_expected.to belong_to(:stack).optional(true) }
    it { is_expected.to belong_to(:modele) }

    it { is_expected.to have_one(:bay).through(:frame) }
    it { is_expected.to have_one(:islet).through(:frame) }
    it { is_expected.to have_one(:room).through(:islet) }
    it { is_expected.to have_one(:site).through(:room) }
    it { is_expected.to have_one(:manufacturer).through(:modele) }

    it { is_expected.to have_many(:cards).dependent(:destroy) }
    it { is_expected.to have_many(:card_types).through(:cards) }
    it { is_expected.to have_many(:ports).through(:cards) }
    it { is_expected.to have_many(:connections).through(:ports) }
    it { is_expected.to have_many(:cables).through(:connections) }
    it { is_expected.to have_many(:moves).dependent(:destroy) }
    it { is_expected.to have_many(:documents) }
    it { is_expected.to have_many(:external_app_records) }
  end

  describe "attachement" do
    it { is_expected.to have_one_attached(:photo) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:numero) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:numero) }
    it { is_expected.not_to allow_value("numero with space").for(:numero) }
  end

  describe ".friendly_find_by_numero_or_name" do
    context "with id" do
      it { expect(described_class.friendly_find_by_numero_or_name(1)).to eq(servers(:one)) }
    end

    context "with numero" do
      it { expect(described_class.friendly_find_by_numero_or_name("ABCDEFG32")).to eq(servers(:two)) }
    end

    context "with slug" do
      it { expect(described_class.friendly_find_by_numero_or_name("server-name-4")).to eq(servers(:four)) }
    end
  end

  describe "#validate_numero_cannot_be_a_current_server_name" do
    before { servers(:one).save }

    context "when numero is server name" do
      subject(:server) do
        described_class.new(name: "ACTARUS", frame: Frame.new, modele: Modele.new, numero: "ACTARUS")
      end

      it { is_expected.to be_valid }
    end

    context "when numero is another server name" do
      subject(:server) do
        described_class.new(name: "ACTARUS", frame: Frame.new, modele: Modele.new, numero: "ServerName1")
      end

      it { is_expected.not_to be_valid }
    end
  end

  describe "#validate_network_types_values" do
    let(:server) { servers(:one) }

    context "when network_types is empty (valid)" do
      it { expect(server).to be_valid }
    end

    context "when network_types is filled with valid values (valid)" do
      before { server.update(network_types: Modele::Network::TYPES.sample(1)) }

      it { expect(server).to be_valid }
    end

    context "when network_types is filled with unvalid values (unvalid)" do
      before do
        server.network_types = ["not_valid_value"]
        server.validate
      end

      it { expect(server).not_to be_valid }
      it { expect(server.errors.key?(:network_types)).to be(true) }
    end
  end

  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:cards) }
    it { is_expected.to accept_nested_attributes_for(:documents) }
  end

  describe ".glpi_synchronizable" do
    it do
      expect(described_class.glpi_synchronizable)
        .to contain_exactly(
          servers(:one), servers(:two), servers(:four), servers(:with_cluster), servers(:accesible_to_readers),
        )
    end
  end

  describe "#to_s" do
    it { expect(server.to_s).to eq server.name }
  end

  describe "#rack_units" do
    it { expect(described_class.new(modele: Modele.new(u: 3), position: 12).rack_units).to eq 10..12 }
    it { expect(described_class.new(modele: Modele.new(u: 1), position: 12).rack_units).to eq 12..12 }
    it { expect(described_class.new(modele: Modele.new(u: 0), position: 12).rack_units).to eq 12..12 }
    it { expect(described_class.new(modele: Modele.new(u: nil), position: 12).rack_units).to eq 12..12 }
    it { expect(described_class.new(modele: Modele.new(u: 3)).rack_units).to be_nil }
  end

  describe "#rack_units_label" do
    it { expect(described_class.new(modele: Modele.new(u: 3), position: 12).rack_units_label).to eq "U10-12" }
    it { expect(described_class.new(modele: Modele.new(u: 1), position: 12).rack_units_label).to eq "U12" }
    it { expect(described_class.new(modele: Modele.new(u: 3)).rack_units_label).to be_nil }
  end

  describe "rack placement validations" do
    # Frame one is 48U high, servers(:two) is at U38 and servers(:one) at U39
    subject(:server) do
      described_class.new(name: "ACTARUS", numero: "1245", frame: frames(:one), modele: Modele.new(u: 3), position:)
    end

    let(:position) { 37 }

    context "without the rack placement context" do
      let(:position) { 39 }

      it { is_expected.to be_valid }
    end

    context "when units are free" do
      it { expect(server.valid?(:rack_placement)).to be true }
    end

    context "when units overlap another server" do
      let(:position) { 40 }

      it do
        server.valid?(:rack_placement)
        expect(server.errors.details[:position]).to contain_exactly(a_hash_including(error: :overlaps))
      end
    end

    context "when the other server is in another frame" do
      before { server.frame = frames(:two) }

      let(:position) { 40 }

      it { expect(server.valid?(:rack_placement)).to be true }
    end

    context "when units go below U1" do
      let(:position) { 2 }

      it do
        server.valid?(:rack_placement)
        expect(server.errors.details[:position]).to contain_exactly(a_hash_including(error: :outside_frame))
      end
    end

    context "when units go above the frame" do
      let(:position) { 49 }

      it do
        server.valid?(:rack_placement)
        expect(server.errors.details[:position]).to contain_exactly(a_hash_including(error: :outside_frame))
      end
    end

    context "when the placement is unchanged on an existing overlap" do
      # servers(:accesible_to_readers) shares U39 with servers(:one)
      subject(:server) { servers(:one) }

      before { server.name = "Renamed" }

      it { expect(server.valid?(:rack_placement)).to be true }
    end
  end

  describe "#should_generate_new_friendly_id?" do
    pending
  end

  describe "#is_a_pdu?" do
    pending
  end

  describe "#is_not_a_pdu?" do
    pending
  end

  describe "#ports_per_type" do
    pending
  end

  describe "#create_missing_ports" do
    pending
  end

  describe "#connected_servers_ids_through_twin_cards_with_color" do
    pending
  end

  describe "#directly_connected_servers_ids" do
    pending
  end

  describe "#directly_connected_servers_ids_with_color" do
    pending
  end

  describe "#connected_ports" do
    pending
  end

  describe "#distant_connections" do
    pending
  end

  describe "#documentation_url" do
    context "with no documentation_url value on manufacturer" do
      let(:server) { described_class.new({ numero: "some" }) }

      it { expect(server.documentation_url).to be_nil }
    end

    context "with no numero on server" do
      let(:server) { described_class.new({ modele_id: 1 }) }

      it { expect(server.documentation_url).to be_nil }
    end

    context "with documentation_url value on manufacturer" do
      let(:server) { servers(:one) }

      it { expect(server.documentation_url).to eq("https://fortinet.com/CZ31535FEY/document") }
    end
  end

  describe "#deep_dup" do
    pending
  end
end
