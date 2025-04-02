# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardDecorator, type: :decorator do
  let(:card) { cards(:one) }
  let(:decorated_card) { card.decorated }

  describe ".card_options_for_select" do
    it { expect(described_class.card_options_for_select.pluck(1)).to match_array(Card.pluck(:id)) }

    it do
      expect(described_class.card_options_for_select.pluck(0)).to \
        match_array(Card.all.map { |card| card.decorated.full_name })
    end
  end

  describe "#full_name" do
    context "with none" do
      let(:card) { Card.build }

      it { expect(decorated_card.full_name).to be_empty }
    end

    context "with just a card name" do
      let(:card) { Card.build(name: "Card name") }

      it { expect(decorated_card.full_name).to eq("Card name") }
    end

    context "with just a composant name" do
      let(:card) { Card.build(composant:) }
      let(:composant) { Composant.build(name: "Composant-A") }

      it { expect(decorated_card.full_name).to eq("Composant-A") }
    end

    context "with just a card type" do
      let(:card) { Card.build(card_type:) }
      let(:card_type) { CardType.build(name: "CardType A") }

      it { expect(decorated_card.full_name).to eq("CardType A") }
    end

    context "with all three together" do
      let(:card) { Card.build(name: "Card name", composant:, card_type:) }
      let(:composant) { Composant.build(name: "Composant-A") }
      let(:card_type) { CardType.build(name: "CardType A") }

      it { expect(decorated_card.full_name).to eq("Card name / Composant-A / CardType A") }
    end
  end
end
