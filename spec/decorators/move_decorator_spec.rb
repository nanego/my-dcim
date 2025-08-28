# frozen_string_literal: true

require "rails_helper"

RSpec.describe MoveDecorator, type: :decorator do
  let(:object) { moves(:planned) }
  let(:decorated_move) { described_class.decorate(object) }

  describe "#status_to_badge_component" do
    subject(:badge) { decorated_move.status_to_badge_component }

    context "with move planned" do
      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :primary }
      it { expect(badge.content).to eq "Planifié" }
    end

    context "with move executed" do
      let(:object) { moves(:executed) }

      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :success }
      it { expect(badge.content).to eq "Exécuté" }
    end
  end

  describe "#steps_options_for_select" do
    let(:object) { moves(:move_step_one) }
    let(:options) { decorated_move.steps_options_for_select }

    it { expect(options).to have_tag("option", count: 3) }
    it { expect(options).to have_tag("option", text: "Step 1", with: { value: 6, selected: "selected" }) }
    it { expect(options).to have_tag("option", text: "Step 2", with: { value: 7 }) }
    it { expect(options).to have_tag("option", text: "Step 3", with: { value: 8 }) }
  end
end
