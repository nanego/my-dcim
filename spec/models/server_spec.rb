# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Server do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:server) do
    described_class.new(name: "ACTARUS", frame: Frame.new, modele: Modele.new, numero: "1245")
  end

  describe "associations" do
    it { is_expected.to belong_to(:frame) }
    it { is_expected.to have_one(:bay).through(:frame) }
    it { is_expected.to have_one(:islet).through(:frame) }
    it { is_expected.to have_one(:room).through(:islet) }
    it { is_expected.to belong_to(:gestion).optional(true) }
    it { is_expected.to belong_to(:domaine).optional(true) }
    it { is_expected.to belong_to(:modele) }
    it { is_expected.to belong_to(:cluster).optional(true) }
    it { is_expected.to belong_to(:server_state).optional(true) }
    it { is_expected.to belong_to(:stack).optional(true) }
    it { is_expected.to have_many(:memory_components) }
    it { is_expected.to have_many(:disks) }
    it { is_expected.to have_many(:cards) }
    it { is_expected.to have_many(:card_types).through(:cards) }
    it { is_expected.to have_many(:ports).through(:cards) }
    it { is_expected.to have_many(:moves).dependent(:destroy) }
    it { is_expected.to have_many(:documents) }
  end

  describe "attachement" do
    it { is_expected.to have_one_attached(:photo) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:numero) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:numero) }
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
    it { is_expected.to accept_nested_attributes_for(:disks) }
    it { is_expected.to accept_nested_attributes_for(:memory_components) }
    it { is_expected.to accept_nested_attributes_for(:documents) }
  end

  describe "#to_s" do
    it { expect(server.to_s).to eq server.name }
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
end
