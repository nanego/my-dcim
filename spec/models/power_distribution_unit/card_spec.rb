# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnit::Card do
  let(:card) { power_distribution_unit_cards(:one) }

  it_behaves_like "a card"

  describe "associations" do
    it { is_expected.to belong_to(:record) }
  end

  describe "#to_s" do
    it { expect(card.to_s).to eq("Carte MyFrame1-A / Card1") }
  end
end
