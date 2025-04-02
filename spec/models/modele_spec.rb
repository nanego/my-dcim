# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Modele do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:modele) { described_class.new(name: "Express5800 - 120RG-2") }

  describe "associations" do
    it { is_expected.to belong_to(:manufacturer) }
    it { is_expected.to belong_to(:architecture) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:servers) }
    it { is_expected.to have_many(:enclosures) }
    it { is_expected.to have_many(:composants).through(:enclosures) }
  end

  describe "#validate_network_types_values" do
    let(:modele) { modeles(:one) }

    context "when network_types is empty (valid)" do
      it { expect(modele).to be_valid }
    end

    context "when network_types is filled with valid values (valid)" do
      before { modele.update(network_types: Modele::Network::TYPES.sample(1)) }

      it { expect(modele).to be_valid }
    end

    context "when network_types is filled with unvalid values (unvalid)" do
      before do
        modele.network_types = ["not_valid_value"]
        modele.validate
      end

      it { expect(modele).not_to be_valid }
      it { expect(modele.errors.key?(:network_types)).to be(true) }
    end
  end

  describe ".glpi_synchronizable" do
    it { expect(described_class.glpi_synchronizable).to contain_exactly(modeles(:one), modeles(:four)) }
  end

  describe ".all_sorted" do
    pending
  end

  describe ".all_sorted_with_servers" do
    pending
  end

  describe "#to_s" do
    it { expect(modele.to_s).to eq modele.name }
  end

  describe "#is_a_pdu?" do
    pending
  end

  describe "#should_generate_new_friendly_id?" do
    pending
  end

  describe "#name_with_brand" do
    pending
  end

  describe "#deep_dup" do
    subject(:modele) { modeles(:one) }

    it { expect(modele.deep_dup).not_to eq(modele) }
    it { expect(modele.deep_dup.name).to eq(modele.name) }
    it { expect(modele.deep_dup.enclosures.size).to eq(modele.enclosures.size) }
  end
end
