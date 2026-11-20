# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnit::Block do
  subject(:block) { described_class.new(position: 3, record: power_distribution_units(:one)) }

  it_behaves_like "changelogable", object: -> { block }, new_attributes: { position: 4 }

  describe "associations" do
    it { is_expected.to belong_to(:record) }
    it { is_expected.to have_many(:sockets).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to be_valid }
  end

  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:sockets) }
  end

  describe "#deep_dup" do
    subject(:power_distribution_unit_block) { power_distribution_unit_blocks(:one) }

    it { expect(power_distribution_unit_block.deep_dup).not_to eq(power_distribution_unit_block) }
    it { expect(power_distribution_unit_block.deep_dup.position).to eq(power_distribution_unit_block.position) }
    it { expect(power_distribution_unit_block.deep_dup.sockets.size).to eq(power_distribution_unit_block.sockets.size) }
  end
end
