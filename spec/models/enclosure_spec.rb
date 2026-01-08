# frozen_string_literal: true

require "rails_helper"

RSpec.describe Enclosure do
  # it_behaves_like "changelogable", new_attributes: { display: "New value" }

  describe "associations" do
    it { is_expected.to belong_to(:modele) }
    it { is_expected.to have_many(:composants).dependent(:destroy) }
  end

  describe ".with_composants" do
    subject(:with_composants) { described_class.with_composants }

    let(:enclosure) { described_class.create!(position: 0, modele: modeles(:one)) }

    it("without composants in enclosure") { is_expected.not_to include(enclosure) }

    it "with two composants in enclosure" do
      expect do
        Composant.create!(position: 0, name: "c1", enclosure:)
        Composant.create!(position: 1, name: "c2", enclosure:)
      end.to change(with_composants, :count).from(0).to(1)
    end
  end

  describe "#deep_dup" do
    subject(:enclosure) { enclosures(:one) }

    it { expect(enclosure.deep_dup).not_to eq(enclosure) }
    it { expect(enclosure.deep_dup.position).to eq(enclosure.position) }
    it { expect(enclosure.deep_dup.composants.size).to eq(enclosure.composants.size) }
  end
end
