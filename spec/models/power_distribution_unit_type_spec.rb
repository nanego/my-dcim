# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitType do
  it_behaves_like "changelogable", object: -> { described_class.new(name: "name", manufacturer: manufacturers(:fortinet), current_type: :three_phase) },
                                   new_attributes: { name: "new name" }

  describe "associations" do
    it { is_expected.to belong_to(:manufacturer) }

    it { is_expected.to have_many(:power_distribution_units).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:circuits).dependent(:destroy) }
    it { is_expected.to have_many(:sockets).through(:circuits) }
  end

  describe "validations" do
    it { is_expected.to define_enum_for(:current_type).with_values(%i[three_phase single_phase]) }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to allow_value("").for(:documentation_url) }
    it { is_expected.to allow_value("http://exemple.com/doc/1").for(:documentation_url) }
    it { is_expected.not_to allow_value("some invalid url").for(:documentation_url) }
  end

  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:circuits) }
  end

  describe "#deep_dup" do
    subject(:power_distribution_unit_type) { power_distribution_unit_types(:one) }

    it { expect(power_distribution_unit_type.deep_dup).not_to eq(power_distribution_unit_type) }
    it { expect(power_distribution_unit_type.deep_dup.name).to eq(power_distribution_unit_type.name) }
    it { expect(power_distribution_unit_type.deep_dup.circuits.size).to eq(power_distribution_unit_type.circuits.size) }

    it do
      expect(power_distribution_unit_type.deep_dup.circuits.map(&:sockets).flatten.size)
        .to eq(power_distribution_unit_type.sockets.size)
    end
  end

  describe "#phases_count" do
    subject(:power_distribution_unit_type) { described_class.new(current_type:) }

    context "with single phase" do
      let(:current_type) { "single_phase" }

      it { expect(power_distribution_unit_type.phases_count).to eq(1) }
    end

    context "with three phase" do
      let(:current_type) { "three_phase" }

      it { expect(power_distribution_unit_type.phases_count).to eq(3) }
    end
  end

  describe "#circuits_per_phase" do
    subject(:power_distribution_unit_type) { described_class.new(current_type:) }

    context "with single phase" do
      let(:current_type) { "single_phase" }

      before do
        3.times { |i| power_distribution_unit_type.circuits.build(name: i) }
      end

      it { expect(power_distribution_unit_type.circuits_per_phase).to eq(3) }
    end

    context "with three phase" do
      let(:current_type) { "three_phase" }

      before do
        6.times { |i| power_distribution_unit_type.circuits.build(name: i) }
      end

      it { expect(power_distribution_unit_type.circuits_per_phase).to eq(2) }
    end
  end
end
