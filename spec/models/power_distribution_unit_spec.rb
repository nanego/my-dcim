# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnit do
  subject(:power_distribution_unit) { power_distribution_units(:one) }

  it_behaves_like "changelogable", object: lambda {
    described_class.new(
      name: "name",
      bay: bays(:one),
      type: power_distribution_unit_types(:one),
      orientation: :asc,
      side: :left,
      serial_number: "A1",
      comment: "",
      ipmi_url: "",
    )
  }, new_attributes: { name: "new name" }

  describe "associations" do
    it { is_expected.to belong_to(:type) }
    it { is_expected.to belong_to(:frame) }

    it { is_expected.to have_many(:circuits).dependent(:destroy) }
    it { is_expected.to have_many(:sockets).through(:circuits) }
    it { is_expected.to have_many(:ports).through(:sockets) }
    it { is_expected.to have_many(:cables).through(:ports) }

    it { is_expected.to have_one(:manufacturer).through(:type) }
    it { is_expected.to have_one(:bay).through(:frame) }
    it { is_expected.to have_one(:islet).through(:frame) }
    it { is_expected.to have_one(:room).through(:frame) }
    it { is_expected.to have_one(:site).through(:room) }
  end

  describe "validations" do
    it { is_expected.to define_enum_for(:orientation).with_values(%i[asc desc]) }
    it { is_expected.to define_enum_for(:side).with_values(%i[left right]) }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:serial_number) }
    it { is_expected.to validate_uniqueness_of(:serial_number) }
    it { is_expected.to allow_value("1234").for(:serial_number) }
    it { is_expected.not_to allow_value("1 234").for(:serial_number) }

    it { is_expected.to allow_value("").for(:ipmi_url) }
    it { is_expected.to allow_value("http://exemple.com/doc/1").for(:ipmi_url) }
    it { is_expected.not_to allow_value("some invalid url").for(:ipmi_url) }
  end

  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:circuits) }
  end

  describe "#to_s" do
    it { expect(power_distribution_unit.to_s).to eq power_distribution_unit.name }
  end

  describe "#should_generate_new_friendly_id?" do
    pending
  end

  describe "#deep_dup" do
    subject(:power_distribution_unit) { power_distribution_units(:one) }

    it { expect(power_distribution_unit.deep_dup).not_to eq(power_distribution_unit) }
    it { expect(power_distribution_unit.deep_dup.name).to eq(power_distribution_unit.name) }
    it { expect(power_distribution_unit.deep_dup.circuits.size).to eq(power_distribution_unit.circuits.size) }

    it do
      expect(power_distribution_unit.deep_dup.circuits.map(&:sockets).flatten.size)
        .to eq(power_distribution_unit.sockets.size)
    end
  end

  describe "#build_circuits_and_sockets_from_type" do
    let!(:power_distribution_unit) do
      described_class.create!(**power_distribution_units(:one).attributes, id: nil, type:, serial_number: "test123456789")
    end
    let(:type) { power_distribution_unit_types(:one) }

    it { expect(power_distribution_unit.circuits.size).to eq(1) }
    it { expect(power_distribution_unit.circuits.first.name).to eq(type.circuits.first.name) }
    it { expect(power_distribution_unit.sockets.size).to eq(2) }
    it { expect(power_distribution_unit.sockets.first.number).to eq(type.sockets.first.number) }
  end
end
