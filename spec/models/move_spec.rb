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
    it { is_expected.to belong_to(:step).class_name("MovesProjectStep") }
    it { is_expected.to belong_to(:moveable) }
    it { is_expected.to belong_to(:frame) }
    it { is_expected.to belong_to(:prev_frame).class_name("Frame") }

    it { is_expected.to have_one(:moves_project).through(:step) }

    it { is_expected.to have_many(:connections).dependent(:destroy) }
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

  describe "default scope" do
    it "orders by ascending created_at" do
      expect(described_class.first(2)).to eq([moves(:two), moves(:one)])
    end
  end

  describe "#remove_existing_connections!" do
    it do
      expect { moves(:planned).remove_existing_connections! }
        .to change(Move::Connection, :count).by(4)
    end

    context "when move is executed" do
      it do
        expect { moves(:executed).remove_existing_connections! }
          .to raise_error(Move::AlreadyExecutedError)
      end
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

    context "without apply_connections" do
      subject(:execution) { move.execute!(apply_connections: false) }

      it do # rubocop:disable RSpec/ExampleLength
        expect do
          execution
          move.reload
        end.to change(move, :executed_at).from(nil)
          .and change(move.moveable, :position).to(move.position)
          .and change(move.moveable, :frame).to(move.frame)
      end

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        move.connections.each do |move_connection|
          expect(move_connection.executed_at).to be_nil
        end

        execution

        move.connections.each do |move_connection|
          expect(move_connection.executed_at).to be_nil
        end
      end
    end

    context "with apply_connections" do
      subject(:execution) { move.execute!(apply_connections: true) }

      it do # rubocop:disable RSpec/ExampleLength
        expect do
          execution
          move.reload
        end.to change(move, :executed_at).from(nil)
          .and change(move.moveable, :position).to(move.position)
          .and change(move.moveable, :frame).to(move.frame)
      end

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        move.connections.each do |move_connection|
          expect(move_connection.executed_at).to be_nil
        end

        execution

        move.connections.each do |move_connection|
          expect(move_connection.executed_at).not_to be_nil
        end
      end
    end

    context "when already executed" do
      let(:move) { moves(:executed) }

      it do
        expect do
          execution
          move.reload
        end.not_to change(move, :executed_at)
      end

      it { expect(execution).to be_nil }
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
