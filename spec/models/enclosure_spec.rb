# frozen_string_literal: true

require "rails_helper"

RSpec.describe Enclosure do
  # it_behaves_like "changelogable", new_attributes: { display: "New value" }

  describe "associations" do
    it { is_expected.to belong_to(:modele) }
    it { is_expected.to have_many(:composants).dependent(:destroy) }
  end

  describe "#validate_grid_areas_match_composants" do
    let(:enclosure) { enclosures(:grid) }

    context "when grid matches" do
      before { enclosure.valid? }

      it { expect(enclosure.errors.where(:grid_areas, :missing_composants).count).to eq(0) }
      it { expect(enclosure.errors.where(:grid_areas, :unknown_composants).count).to eq(0) }
    end

    context "when a composant is missing" do
      before do
        enclosure.grid_areas = ""
        enclosure.valid?
      end

      it { expect(enclosure.errors.where(:grid_areas, :missing_composants).count).to eq(1) }
      it { expect(enclosure.errors.where(:grid_areas, :unknown_composants).count).to eq(0) }
    end

    context "when unknown composant" do
      before do
        enclosure.grid_areas = "unknown SL5"
        enclosure.valid?
      end

      it { expect(enclosure.errors.where(:grid_areas, :missing_composants).count).to eq(0) }
      it { expect(enclosure.errors.where(:grid_areas, :unknown_composants).count).to eq(1) }
    end

    context "when unknown composant and a composant missing" do
      before do
        enclosure.grid_areas = "unknown"
        enclosure.valid?
      end

      it { expect(enclosure.errors.where(:grid_areas, :missing_composants).count).to eq(1) }
      it { expect(enclosure.errors.where(:grid_areas, :unknown_composants).count).to eq(1) }
    end
  end

  describe ".with_composants" do
    subject(:with_composants) { modele.enclosures.with_composants }

    let(:modele)    { modeles(:four) }
    let(:enclosure) { described_class.create!(position: 0, modele:) }

    before { enclosure }

    context "without composants in enclosure" do
      it { is_expected.not_to include(enclosure) }
    end

    context "with two composants in enclosure" do
      it do
        expect do
          Composant.create!(position: 0, name: "c1", enclosure:)
          Composant.create!(position: 1, name: "c2", enclosure:)
        end.to change(with_composants, :count).from(0).to(1)
      end
    end

    context "with empty enclosure" do
      before do
        Composant.create!(position: 0, name: "c1", enclosure:)
        Composant.create!(position: 1, name: "c2", enclosure:)
      end

      it do
        expect do
          described_class.create!(position: 0, modele: modeles(:four))
        end.not_to change(with_composants, :count)
      end
    end
  end

  describe "#deep_dup" do
    subject(:enclosure) { enclosures(:one) }

    it { expect(enclosure.deep_dup).not_to eq(enclosure) }
    it { expect(enclosure.deep_dup.position).to eq(enclosure.position) }
    it { expect(enclosure.deep_dup.composants.size).to eq(enclosure.composants.size) }
  end
end
