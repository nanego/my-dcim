# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardTypesProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { CardType.all }
  let(:params) { {} }

  describe "when searching" do
    let(:params) { { q: "wood" } }

    before do
      CardType.create!(name: "brick", port_type: port_types(:two))
      CardType.create!(name: "wood", port_type: port_types(:two))
      CardType.create!(name: "wooden", port_type: port_types(:two))
    end

    # IMPROVE
    it { expect(result.size).to eq(2) }
  end

  describe "when filtering by port_type_ids" do
    let(:port_type) { PortType.create!(name: "PT1") }
    let(:card_type) { CardType.create!(name: "CT1", port_type:) }

    before do
      card_type
      CardType.create!(name: "CT2", port_type: port_types(:two))
    end

    context "with one port_type_ids" do
      let(:params) { { port_type_ids: port_type.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(card_type) }
    end

    context "with many port_type_ids" do
      let(:port_type_second) { PortType.create!(name: "PT2") }
      let(:card_type_second) { CardType.create!(name: "CT2", port_type: port_type_second) }

      let(:params) { { port_type_ids: [port_type.id, port_type_second.id] } }

      before do
        card_type_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(card_type, card_type_second) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end

  describe "When searching on every fields" do
    let(:port_type) { PortType.create!(name: "PT1") }
    let(:card_type) { CardType.create!(name: "wood", port_type:) }

    let(:params) { { q: "wood", port_type_ids: port_type.id } }

    before { card_type }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(card_type) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "and sort on #{field}" do # rubocop:disable RSpec/ContextWording
        let(:params) { { q: "wood", port_type_ids: port_type.id, sort_by: field } }

        it { expect(result.size).to eq(1) }
        it { is_expected.to contain_exactly(card_type) }
      end
    end
  end
end
