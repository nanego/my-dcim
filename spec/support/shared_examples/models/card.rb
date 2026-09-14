# frozen_string_literal: true

shared_examples_for "a card" do
  describe "associations" do
    it { is_expected.to belong_to(:card_type) }
    it { is_expected.to have_many(:ports).dependent(:destroy) }
    it { is_expected.to have_many(:cables).through(:ports) }
    it { is_expected.to have_many(:connections).through(:ports) }
  end

  describe "validations" do
    it { is_expected.to validate_numericality_of(:first_position).only_integer.is_in(0..100).allow_nil }
  end

  describe "#ensure_card_type_have_enough_ports" do
    before do
      card.card_type = card_type
      card.validate
    end

    context "when enough ports" do
      let(:card_type) { card_types(:four) }

      it { expect(card).to be_valid }
    end

    context "when not enough ports" do
      let(:card) { cards(:one) }
      let(:card_type) { card_types(:two) }

      it { expect(card).not_to be_valid }
      it { expect(card.errors.where(:card_type_id, :not_enough_ports).count).to eq(1) }
    end
  end

  describe "first_port_position" do
    pending
  end

  describe "positions_with_ports" do
    pending
  end

  describe "create_missing_ports" do
    pending
  end
end
