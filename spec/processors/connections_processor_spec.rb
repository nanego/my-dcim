# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConnectionsProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { Connection.all }
  let(:params) { {} }

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
      it { is_expected.to contain_exactly(connection) }
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
      it { is_expected.to contain_exactly(connection, connection_second) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end
end
