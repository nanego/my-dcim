# frozen_string_literal: true

require "rails_helper"

RSpec.describe Move::ConnectionDecorator, type: :decorator do
  let(:object) { move_connections(:one) }
  let(:decorated_mc) { described_class.decorate(object) }

  describe "#status_to_badge_component" do
    subject(:badge) { decorated_mc.status_to_badge_component }

    context "with executed_at = nil" do
      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :primary }
      it { expect(badge.content).to eq "Planifié" }
    end

    context "with executed_at not nil" do
      before { object.executed_at = Date.new }

      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :success }
      it { expect(badge.content).to eq "Exécuté" }
    end
  end

  describe "#description" do
    it do
      expect(decorated_mc.description).to eq <<~TEXT.squish
        Connexion entre MyString ReadableServer (port #9) et MyString ReadableServer (port #10) => vlans : vlan01 // nom du câble : NouveauNomDuCableUn // couleur : Blue
      TEXT
    end
  end

  describe "#action" do
    subject(:action) { decorated_mc.action }

    context "when port to nil" do
      let(:object) { move_connections(:four) }

      it { is_expected.to be(:destroy) }
    end

    context "when port to not nil and port from has a connection" do
      let(:object) { move_connections(:three) }

      it { is_expected.to be(:update) }
    end

    context "when port to not nil and port from has no connection" do
      let(:object) { move_connections(:one) }

      it { is_expected.to be(:create) }
    end
  end

  describe "#human_action" do
    subject(:human_action) { decorated_mc.human_action }

    context "when port to nil" do
      let(:object) { move_connections(:four) }

      it { is_expected.to eq("Suppression") }
    end

    context "when port to not nil and port from has a connection" do
      let(:object) { move_connections(:three) }

      it { is_expected.to eq("Modification") }
    end

    context "when port to not nil and port from has no connection" do
      let(:object) { move_connections(:one) }

      it { is_expected.to eq("Création") }
    end
  end

  describe "#action_badge_color" do
    subject(:action) { decorated_mc.action_badge_color }

    context "when port to nil" do
      let(:object) { move_connections(:four) }

      it { is_expected.to be(:danger) }
    end

    context "when port to not nil and port from has a connection" do
      let(:object) { move_connections(:three) }

      it { is_expected.to be(:info) }
    end

    context "when port to not nil and port from has no connection" do
      let(:object) { move_connections(:one) }

      it { is_expected.to be(:success) }
    end
  end

  describe "#extra_connection_destroyed?" do
    subject(:action) { decorated_mc.extra_connection_destroyed? }

    context "when port to has a connection" do
      let(:object) { move_connections(:five) }

      it { is_expected.to be(true) }
    end

    context "when port to has no connection" do
      let(:object) { move_connections(:one) }

      it { is_expected.to be(false) }
    end

    context "when port to is nil" do
      let(:object) { move_connections(:four) }

      it { is_expected.to be(false) }
    end
  end
end
