# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovedConnectionDecorator, type: :decorator do
  let(:moved_connection) { moved_connections(:one) }
  let(:decorated_moved_connection) { moved_connection.decorated }

  describe "#description" do
    it do
      expect(decorated_moved_connection.description)
        .to eq("Connexion entre MyString ServerName1 (port #1) et MyString ServerName1 " \
               "(port #2) => vlans:vlan01 cablename:NouveauNomDuCableUn couleur:Blue")
    end
  end
end
