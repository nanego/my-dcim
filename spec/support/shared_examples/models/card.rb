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
  end

  describe "first_port_position" do
    let(:first_port_position) { card.first_port_position }

    context "when first_position on card" do
      before { card.first_position = 0 }

      it { expect(first_port_position).to eq(0) }
    end

    context "when first_position on card type" do
      before do
        card.first_position = nil
        card.card_type.first_position = 0
      end

      it { expect(first_port_position).to eq(0) }
    end

    context "with no defined first_position" do
      before do
        card.first_position = nil
        card.card_type.first_position = nil
      end

      it { expect(first_port_position).to eq(1) }
    end
  end

  describe "positions_with_ports" do
    let(:positions_with_ports) { card.positions_with_ports }

    before { card.ports = Array.new(4) { |position| Port.build(position:) } }

    it { expect(positions_with_ports).to eq([0, 1, 2, 3]) }
  end

  describe "create_missing_ports" do
    let(:execution) { card.create_missing_ports }
    let(:port_quantity) { 4 }
    let(:created_port_positions) { [2] }

    let(:create_base) { { attachable: card, vlans: nil, color: nil, cablename: nil } }

    before do
      allow(Port).to receive(:create)
      card.card_type.port_quantity = port_quantity
      allow(card).to receive(:positions_with_ports)
        .and_return(created_port_positions)

      execution
    end

    context "without created ports" do
      let(:created_port_positions) { [] }

      it { expect(Port).to have_received(:create).exactly(4).times }

      (1..4).each do |position|
        it { expect(Port).to have_received(:create).with(create_base.merge(position:)) }
      end
    end

    context "with created ports" do
      let(:created_port_positions) { [3] }

      it { expect(Port).to have_received(:create).exactly(3).times }

      [1, 2, 4].each do |position|
        it { expect(Port).to have_received(:create).with(create_base.merge(position:)) }
      end
    end

    context "without missing ports" do
      let(:created_port_positions) { (1..4).to_a }

      it { expect(Port).to have_received(:create).exactly(0).times }
    end
  end
end
