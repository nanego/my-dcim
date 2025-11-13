# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovedConnectionDecorator, type: :decorator do
  let(:object) { moved_connections(:one) }
  let(:decorated_mc) { described_class.decorate(object) }

  describe "#description" do
    it do
      expect(decorated_mc.description)
        .to eq("Connexion entre MyString ServerName1 (port #1) et MyString ServerName1 (port #2) => vlans : vlan01 // nom du câble : NouveauNomDuCableUn // couleur : Blue")
    end

    context "without port_to" do
      let(:object) { moved_connections(:one).tap { |c| c.port_to = nil } }

      it do
        expect(decorated_mc.description)
          .to eq("Connexion entre MyString ServerName1 (port #1) et  (port #) => vlans : vlan01 // nom du câble : NouveauNomDuCableUn // couleur : Blue")
      end
    end
  end
end
