# frozen_string_literal: true

require "rails_helper"

RSpec.describe MoveDecorator, type: :decorator do
  let(:object) { moves(:planned) }
  let(:decorated_move) { described_class.decorate(object) }

  describe "#steps_options_for_select" do
    let(:object) { moves(:move_step_one) }
    let(:options) { decorated_move.steps_options_for_select }

    it { expect(options).to have_tag("option", count: 3) }
    it { expect(options).to have_tag("option", text: "Step 1", with: { value: 6, selected: "selected" }) }
    it { expect(options).to have_tag("option", text: "Step 2", with: { value: 7 }) }
    it { expect(options).to have_tag("option", text: "Step 3", with: { value: 8 }) }
  end

  describe "#status_to_badge_component" do
    subject(:badge) { decorated_move.status_to_badge_component }

    context "with move planned" do
      it { is_expected.to be_a(BadgeComponent) }
      it { expect(badge.instance_variable_get(:@color)).to eq(:primary) }

      it do
        expect(badge.content).to eq(
          "<span><span class=\"bi bi-calendar-event\"></span><span class=\"ms-1\">Planifié</span></span>",
        )
      end
    end

    context "with move executed" do
      let(:object) { moves(:executed) }

      it { is_expected.to be_a(BadgeComponent) }
      it { expect(badge.instance_variable_get(:@color)).to eq(:success) }

      it do
        expect(badge.content).to eq(
          "<span><span class=\"bi bi-calendar-check\"></span><span class=\"ms-1\">Exécuté</span></span>",
        )
      end
    end

    context "without text" do
      subject(:badge) { decorated_move.status_to_badge_component(with_text: false) }

      it { is_expected.to be_a(BadgeComponent) }

      it do
        expect(badge.content).to eq(
          "<span><span class=\"bi bi-calendar-event\"></span></span>",
        )
      end
    end
  end

  describe "#moved_connections_to_badge_component" do
    subject(:badge) { decorated_move.moved_connections_to_badge_component }

    context "with moved_connections" do
      let(:object) { moves(:one).tap { |move| move.remove_existing_connections_on_execution = true } }

      it { is_expected.to be_a(BadgeComponent) }
      it { expect(badge.instance_variable_get(:@color)).to eq(:success) }
      it { expect(badge.content).to eq("Oui") }
    end

    context "without moved_connections" do
      let(:object) { Move.new }

      it { is_expected.to be_a(BadgeComponent) }
      it { expect(badge.instance_variable_get(:@color)).to eq(:danger) }
      it { expect(badge.content).to eq("Non") }
    end
  end

  describe "#display_name" do
    it { expect(decorated_move.display_name).to eq("Déplacement de ServerName1") }
  end

  describe "#planned_or_executed_date" do
    context "with not executed move and no planned date" do
      it { expect(decorated_move.planned_or_executed_date).to be_nil }
    end

    context "with executed move and no planned date" do
      let(:object) { moves(:executed) }

      it { expect(decorated_move.planned_or_executed_date).to eq("01/05/25 à 02h00") }
    end

    context "with executed move and planned date" do
      let(:object) { moves(:move_step_one) }

      before { object.executed_at = "2025-05-01 00:00:00" }

      it { expect(decorated_move.planned_or_executed_date).to eq("01/05/25 à 00h00") }
    end

    context "with not executed move and planned date" do
      let(:object) { moves(:move_step_one) }

      it { expect(decorated_move.planned_or_executed_date).to eq("06/06/2025") }
    end
  end
end
