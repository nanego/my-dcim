# frozen_string_literal: true

require "rails_helper"

RSpec.describe CablesProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { Cable.all }
  let(:params) { {} }

  describe "when searching by cable name" do
    let(:cable) { Cable.create!(name: "cableA") }

    let(:params) { { cable_name: "cableA" } }

    before { cable }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(cable) }
  end

  describe "when searching by special_case" do
    let(:cable) { Cable.create!(special_case: true) }

    let(:params) { { special_case: "true" } }

    before { cable }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(cable) }
  end

  describe "when searching by color" do
    let(:cable) { Cable.create!(color: "V") }

    before { cable }

    context "with one color" do
      let(:params) { { colors: "V" } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(cable) }
    end

    context "with two colors" do
      let(:second_cable) { Cable.create!(color: "B") }
      let(:params) { { colors: %w[V B] } }

      before { second_cable }

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(cable, second_cable) }
    end
  end

  describe "when searching by comments" do
    let(:cable) { Cable.create!(comments: "This is a comment") }

    let(:params) { { comments: "comment" } }

    before { cable }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(cable) }
  end

  describe "when searching by vlans" do
    let(:port) { Port.create!(vlans: "vlan1", card: cards(:one)) }
    let(:cable) { Cable.create!(name: "cableA") }
    let(:connection) { Connection.create!(cable:, port:) }

    let(:params) { { vlans: "vlan1" } }

    before { connection }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(cable) }
  end

  describe "when filtering by server_ids" do
    let(:server) { Server.create!(name: "A", numero: "numeroA", frame: frames(:one), modele: modeles(:one)) }
    let(:card) do
      Card.create!(server:, card_type: card_types(:one), composant: composants(:one))
    end
    let(:port) { Port.create!(card:) }
    let(:cable) { Cable.create!(name: "cableA") }
    let(:connection) { Connection.create!(cable:, port:) }

    before { connection }

    context "with one server_ids" do
      let(:params) { { server_ids: server.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(cable) }
    end

    context "with many server_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:server_second) { Server.create!(name: "B", numero: "numeroB", frame: frames(:one), modele: modeles(:one)) }
      let(:card_second) do
        Card.create!(server: server_second, card_type: card_types(:one), composant: composants(:one))
      end
      let(:port_second) { Port.create!(card: card_second) }
      let(:cable_second) { Cable.create!(name: "cableB") }
      let(:connection_second) { Connection.create!(cable: cable_second, port: port_second) }

      let(:params) { { server_ids: [server.id, server_second.id] } }

      before do
        connection_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(cable, cable_second) }
    end
  end

  describe "when filtering by port_type_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:server) { Server.create!(name: "A", numero: "numeroA", frame: frames(:one), modele: modeles(:one)) }
    let(:card) do
      Card.create!(server:, card_type:, composant: composants(:one))
    end
    let(:port) { Port.create!(card:) }
    let(:cable) { Cable.create!(name: "cableA") }
    let(:connection) { Connection.create!(cable:, port:) }
    let(:card_type) { CardType.create!(port_type:) }
    let(:port_type) { PortType.create!(name: "PortType A") }

    before { connection }

    context "with one port_type_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:params) { { port_type_ids: port_type.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(cable) }
    end

    context "with many port_type_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:server_second) { Server.create!(name: "B", numero: "numeroB", frame: frames(:one), modele: modeles(:one)) }
      let(:card_second) do
        Card.create!(server: server_second, card_type: card_type_second, composant: composants(:one))
      end
      let(:port_second) { Port.create!(card: card_second) }
      let(:cable_second) { Cable.create!(name: "cableB") }
      let(:connection_second) { Connection.create!(cable: cable_second, port: port_second) }
      let(:card_type_second) { CardType.create!(port_type: port_type_second) }
      let(:port_type_second) { PortType.create!(name: "PortType B") }

      let(:params) { { port_type_ids: [port_type.id, port_type_second.id] } }

      before do
        connection_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(cable, cable_second) }
    end
  end

  describe "when searching by card name, card type or composant name" do
    let(:card) do
      Card.create!(server: servers(:one), card_type: card_types(:one), composant: composants(:one), name: "Card A")
    end
    let(:port) { Port.create!(card:) }
    let(:cable) { Cable.create!(name: "cableA") }
    let(:connection) { Connection.create!(cable:, port:) }

    before { connection }

    context "with a card name" do
      let(:params) { { card_query: "Card A" } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(cable) }
    end

    context "with a card type" do
      let(:card_type) { CardType.create!(name: "Card Type A", port_type: port_types(:one)) }
      let(:card) do
        Card.create!(server: servers(:one), card_type:, composant: composants(:one))
      end

      let(:params) { { card_query: "Card Type A" } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(cable) }
    end

    context "with a composant name" do
      let(:card) do
        Card.create!(server: servers(:one), card_type: card_types(:one), composant:)
      end
      let(:composant) do
        Composant.create!(name: "Composant-A", enclosure: enclosures(:one))
      end

      let(:params) { { card_query: "Composant-A" } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(cable) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end

  describe "When searching on every fields" do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:server)     { Server.create!(name: "A", numero: "numeroA", frame: frames(:one), modele: modeles(:one)) }
    let(:card_type)  { CardType.create!(port_type:) }
    let(:port_type)  { PortType.create!(name: "PortType A") }
    let(:card)       { Card.create!(name: "Card A", server:, card_type:, composant: composants(:one)) }
    let(:port)       { Port.create!(vlans: "vlan1", card:) }
    let(:cable)      { Cable.create!(name: "cableA", special_case: true, color: "V", comments: "This is a comment") }
    let(:connection) { Connection.create!(cable:, port:) }

    let(:params) do
      {
        cable_name: "cableA", special_case: "true", color: "V", comments: "comment", vlans: "vlan1",
        server_ids: server.id, port_type_ids: port_type.id, card_query: "Card A"
      }
    end

    before { connection }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(cable) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "and sort on #{field}" do # rubocop:disable RSpec/ContextWording, RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            cable_name: "cableA", special_case: "true", color: "V", comments: "comment", vlans: "vlan1",
            server_ids: server.id, port_type_ids: port_type.id, card_query: "Card A", sort_by: field
          }
        end

        it { expect(result.size).to eq(1) }
        it { is_expected.to contain_exactly(cable) }
      end
    end
  end
end
