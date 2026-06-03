# frozen_string_literal: true

require "rails_helper"

RSpec.describe Move::ConnectionDecorator, type: :decorator do
  let(:object) { move_connections(:one) }
  let(:decorated_mc) { described_class.decorate(object) }

  describe "#description" do
    it do
      expect(decorated_mc.description)
        .to eq("Connexion entre MyString ReadableServer (port #9) et MyString ReadableServer (port #10) => vlans : vlan01 // nom du câble : NouveauNomDuCableUn // couleur : Blue")
    end

    context "without port_to" do
      let(:object) { move_connections(:one).tap { |c| c.port_to = nil } }

      it do
        expect(decorated_mc.description)
          .to eq("Connexion entre MyString ReadableServer (port #9) et  (port #) => vlans : vlan01 // nom du câble : NouveauNomDuCableUn // couleur : Blue")
      end
    end
  end
end
