# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovesProjectStep do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:move_project_step) { described_class.new(name: "A", moves_project:) }

  let(:moves_project) { MovesProject.new(name: "A") }

  describe "associations" do
    it { is_expected.to belong_to(:moves_project) }
    it { is_expected.to have_many(:moves) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#to_s" do
    it { expect(move_project_step.to_s).to eq("A") }
  end

  describe "#execute!" do
    pending
  end

  describe "#executed?" do
    it { expect(moves_project_steps(:planned).executed?).to be(false) }

    context "when executed" do
      it { expect(moves_project_steps(:executed).executed?).to be(true) }
    end
  end

  describe "#frames_with_moves_at_current_step" do
    it do
      expect(moves_project_steps(:planned).frames_with_moves_at_current_step)
        .to contain_exactly(frames(:one), frames(:three))
    end
  end

  describe "#servers_moves_for_frame_at_current_step" do
    context "with a move in a one-step project" do
      it do
        expect(moves_project_steps(:planned).servers_moves_for_frame_at_current_step(frames(:one)))
          .to contain_exactly(servers(:two), servers(:with_cluster), servers(:accesible_to_readers))
      end
    end

    context "with a move in a multi-steps project" do
      it do
        expect(moves_project_steps(:step_one).servers_moves_for_frame_at_current_step(frames(:one)))
          .to contain_exactly(servers(:two), servers(:with_cluster), servers(:accesible_to_readers))
      end

      it do
        expect(moves_project_steps(:step_one).servers_moves_for_frame_at_current_step(frames(:three)))
          .to contain_exactly(servers(:one))
      end

      it do
        expect(moves_project_steps(:step_two).servers_moves_for_frame_at_current_step(frames(:one)))
          .to contain_exactly(servers(:two), servers(:with_cluster), servers(:accesible_to_readers))
      end

      it do
        expect(moves_project_steps(:step_two).servers_moves_for_frame_at_current_step(frames(:three)))
          .to be_empty
      end

      it do
        expect(moves_project_steps(:step_three).servers_moves_for_frame_at_current_step(frames(:one)))
          .to contain_exactly(servers(:two), servers(:with_cluster), servers(:accesible_to_readers))
      end

      it do
        expect(moves_project_steps(:step_three).servers_moves_for_frame_at_current_step(frames(:four)))
          .to contain_exactly(servers(:two), servers(:four), servers(:hub_network2))
      end
    end

    context "with an equipment being moved in the same frame" do
      let(:servers_array) do
        moves_project_steps(:step_same_frame_move).servers_moves_for_frame_at_current_step(frames(:one))
      end

      it do
        expect(servers_array)
          .to contain_exactly(servers(:one), servers(:two), servers(:with_cluster), servers(:accesible_to_readers))
      end

      it { expect(servers_array.first).to eq(servers(:one)) }
      it { expect(servers_array.first.position).to eq(41) }
    end

    context "with an equipment being moved back in the same frame" do
      let(:servers_array) do
        moves_project_steps(:second_step_move_back).servers_moves_for_frame_at_current_step(frames(:one))
      end

      it do
        expect(servers_array)
          .to contain_exactly(servers(:one), servers(:two), servers(:with_cluster), servers(:accesible_to_readers))
      end

      it { expect(servers_array.first).to eq(servers(:one)) }
      it { expect(servers_array.first.position).to eq(41) }
    end
  end

  describe "#previous_steps" do
    context "with a project with many steps" do
      let(:step_one) { moves_project_steps(:step_one) }
      let(:step_two) { moves_project_steps(:step_two) }
      let(:step_three) { moves_project_steps(:step_three) }

      it { expect(step_one.previous_steps).to be_empty }
      it { expect(step_two.previous_steps).to contain_exactly(step_one) }
      it { expect(step_three.previous_steps).to contain_exactly(step_one, step_two) }
    end
  end

  describe "#previous_step" do
    context "with a project with many steps" do
      let(:step_one) { moves_project_steps(:step_one) }
      let(:step_two) { moves_project_steps(:step_two) }

      it { expect(step_one.previous_step).to be_nil }
      it { expect(step_two.previous_step).to eq(step_one) }
    end
  end
end
