# frozen_string_literal: true

require "rails_helper"

RSpec.describe Card do
  let(:card) { cards(:one) }

  it_behaves_like "a card"

  # it_behaves_like "changelogable", object: -> { described_class.new }, new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to belong_to(:server) }
    it { is_expected.to belong_to(:composant) }
  end

  describe "#to_s" do
    it { expect(card.to_s).to eq("Carte ServerName1 / Card1 / compo1") }
  end

  describe "#set_twin_card" do
    pending
  end
end
