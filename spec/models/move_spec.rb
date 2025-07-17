# frozen_string_literal: true

require "rails_helper"

RSpec.describe Move do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:move) do
    described_class.new(
      step: MovesProjectStep.new, moveable: Server.new, position: 1, frame: Frame.new, prev_frame: Frame.new
    )
  end

  describe "associations" do
    it { is_expected.to belong_to(:step) }
    it { is_expected.to belong_to(:moveable) }
    it { is_expected.to belong_to(:prev_frame) }
    it { is_expected.to belong_to(:frame) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:position) }

    context "when server already been move in this step" do
      let(:other_move) do
        described_class.create(
          moveable: moves(:one).moveable, step: moves(:one).step, position: 1, frame: Frame.new, prev_frame: Frame.new
        )
      end

      it { expect(other_move.errors.where(:moveable_id, :taken).count).to eq(1) }
    end
  end

  describe "#clear_connections" do
    pending
  end

  describe "#status" do
    it { expect(move.status).to eq(:planned) }

    context "when executed" do
      before { move.executed_at = Time.zone.now }

      it { expect(move.status).to eq(:executed) }
    end
  end

  describe "#execute!" do
    pending
  end

  describe "#executed?" do
    it { expect(move.executed?).to be(false) }

    context "when executed" do
      before { move.executed_at = Time.zone.now }

      it { expect(move.executed?).to be(true) }
    end
  end

  describe "#refresh_prev_data" do
    let(:move) { moves(:one) }

    before do
      move.moveable.frame_id = 2
      move.moveable.position = 3

      move.save
    end

    it { expect(move.prev_frame_id).to eq(2) }
    it { expect(move.prev_position).to eq(3) }
  end
end
