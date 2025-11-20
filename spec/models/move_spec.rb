# frozen_string_literal: true

require "rails_helper"

RSpec.describe Move do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:move) do
    described_class.new(
      step: MovesProjectStep.new, moveable: Server.new, position: 1, frame: Frame.new, prev_frame: Frame.new,
    )
  end

  describe "associations" do
    it { is_expected.to belong_to(:step) }
    it { is_expected.to belong_to(:moveable) }
    it { is_expected.to belong_to(:prev_frame) }
    it { is_expected.to belong_to(:frame) }

    it { is_expected.to have_one(:moves_project).through(:step) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:position) }

    context "when server already been move in this step" do
      let(:other_move) do
        described_class.create(
          moveable: moves(:one).moveable, step: moves(:one).step, position: 1, frame: Frame.new, prev_frame: Frame.new,
        )
      end

      it { expect(other_move.errors.where(:moveable_id, :taken).count).to eq(1) }
    end
  end

  describe "#clear_connections" do
    let(:move) { moves(:planned) }

    it { expect { move.clear_connections }.to change { move.moved_connections.count }.from(2).to(0) }

    context "when remove_connections set to true" do
      let(:move) { moves(:planned).tap { |m| m.remove_connections = true } }

      it { expect { move.clear_connections }.to change { move.moved_connections.count }.from(2).to(4) }
    end
  end

  describe "#status" do
    it { expect(move.status).to eq(:planned) }

    context "when executed" do
      before { move.executed_at = Time.zone.now }

      it { expect(move.status).to eq(:executed) }
    end
  end

  describe "#execute!" do
    subject(:execution) { move.execute! }

    let(:move) { moves(:planned) }

    it do
      expect do
        execution
        move.reload
      end.to change(move, :executed_at).from(nil)
        .and change(move.moveable, :position)
    end

    context "with connections" do
      pending "# TODO"
    end

    context "when already executed" do
      let(:move) { moves(:executed) }

      pending "# TODO"
    end
  end

  describe "#executed?" do
    it { expect(move.executed?).to be(false) }

    context "when executed" do
      before { move.executed_at = Time.zone.now }

      it { expect(move.executed?).to be(true) }
    end
  end

  describe "#previous_moves" do
    context "with a move in a one-step project" do
      it { expect(move.previous_moves).to be_nil }
    end

    context "with a move in a multi-steps project" do
      let(:move_step_one) { moves(:move_step_one) }
      let(:move_step_two) { moves(:move_step_two) }
      let(:move_step_four) { moves(:move_step_four) }

      it { expect(move_step_one.previous_moves).to be_nil }
      it { expect(move_step_two.previous_moves).to contain_exactly(move_step_one) }
      it { expect(move_step_four.previous_moves).to contain_exactly(move_step_two, moves(:move_step_three)) }
    end
  end

  describe "#refresh_prev_data" do
    context "with a move in a one-step project" do
      let(:move) { moves(:one) }

      before do
        move.moveable.frame_id = 2
        move.moveable.position = 3

        move.save
      end

      it { expect(move.prev_frame_id).to eq(2) }
      it { expect(move.prev_position).to eq(3) }
    end

    context "with a move in a multi-steps project" do
      let(:move) { moves(:move_step_two) }

      before { move.save }

      it { expect(move.prev_frame_id).to eq(3) }
      it { expect(move.prev_position).to eq(40) }
    end
  end
end
