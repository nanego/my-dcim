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

  describe ".all_sorted" do
    pending
  end

  describe ".all_sorted_with_servers" do
    pending
  end
end
