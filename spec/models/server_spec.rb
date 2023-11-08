# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Server, type: :model do
  subject(:server) do
    Server.new(name: "ACTARUS", frame: Frame.new, modele: Modele.new, numero: "1245")
  end

  let(:frame) { Frame.new }
  let(:modele) { Modele.new }

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
    it { is_expected.to have_one(:maintenance_contract) }
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
    xit { is_expected.to validate_uniqueness_of(:numero) }
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
