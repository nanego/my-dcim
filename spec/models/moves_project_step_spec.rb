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
    it do
      expect(moves_project_steps(:planned).servers_moves_for_frame_at_current_step(frames(:one)))
        .to contain_exactly(servers(:two), servers(:with_cluster))
    end
  end
end
