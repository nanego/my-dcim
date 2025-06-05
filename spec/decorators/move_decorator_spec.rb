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
end
