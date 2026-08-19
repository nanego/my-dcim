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
end
