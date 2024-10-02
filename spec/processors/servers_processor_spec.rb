# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServersProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { Server.all }
  let(:params) { {} }

  let(:attributes) do
    {
      frame: frames(:one), gestion: gestions(:one), domaine: domaines(:switch), modele: modeles(:one),
      cluster: clusters(:cloud_c1), server_state: server_states(:one), stack: stacks(:red)
    }
  end

  describe "when searching" do
    let(:params) { { q: "wood" } }

    before do
      Server.create!(name: "brick", numero: 1, **attributes)
      Server.create!(name: "wood", numero: 2, **attributes)
      Server.create!(name: "wooden", numero: 3, **attributes)
    end

    # IMPROVE
    it { expect(result.size).to eq(2) }
  end

  describe "when filtering by frame_ids" do
    let(:frame)  { Frame.create!(name: "A1", bay: bays(:one)) }
    let(:server) { Server.create!(name: "server", numero: 1, **attributes, frame:) }

    let(:params) { { frame_ids: frame.id } }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(server) }
  end

  describe "when filtering by bay_ids" do
    let(:bay)    { Bay.create!(name: "A1", islet: islets(:one), bay_type: bay_types(:one)) }
    let(:frame)  { Frame.create!(name: "A1", bay:) }
    let(:server) { Server.create!(name: "server", numero: 1, **attributes, frame:) }

    let(:params) { { bay_ids: bay.id } }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(server) }
  end

  describe "when filtering by islet_ids" do
    let(:islet)  { Islet.create!(name: "I1", site: sites(:one)) }
    let(:bay)    { Bay.create!(name: "A1", islet: islet, bay_type: bay_types(:one)) }
    let(:frame)  { Frame.create!(name: "A1", bay:) }
    let(:server) { Server.create!(name: "server", numero: 1, **attributes, frame:) }

    let(:params) { { islet_ids: islet.id } }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(server) }
  end

  describe "when filtering by room_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:room)   { Room.create(name: "R1", site: sites(:one)) }
    let(:islet)  { Islet.create!(name: "I1", room:) }
    let(:bay)    { Bay.create!(name: "A1", islet: islet, bay_type: bay_types(:one)) }
    let(:frame)  { Frame.create!(name: "A1", bay:) }
    let(:server) { Server.create!(name: "server", numero: 1, **attributes, frame:) }

    let(:params) { { room_ids: room.id } }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(server) }
  end

  describe "when filtering by modele_ids" do
    let(:modele) do
      Modele.create!(name: "M1", manufacturer: manufacturers(:fortinet), architecture: architectures(:rackable), category: categories(:one))
    end

    let(:server) { Server.create!(name: "server", numero: 1, **attributes, modele:) }

    let(:params) { { modele_ids: modele.id } }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(server) }
  end

  describe "when filtering by gestion_ids" do
    let(:gestion) { Gestion.create!(name: "G1") }
    let(:server) { Server.create!(name: "server", numero: 1, **attributes, gestion:) }

    let(:params) { { gestion_ids: gestion.id } }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(server) }
  end

  describe "when filtering by domaine_ids" do
    let(:domaine) { Domaine.create!(name: "D1") }
    let(:server)  { Server.create!(name: "server", numero: 1, **attributes, domaine:) }

    let(:params) { { domaine_ids: domaine.id } }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(server) }
  end

  describe "when filtering by cluster_ids" do
    let(:cluster) { Cluster.create!(name: "C1") }
    let(:server)  { Server.create!(name: "server", numero: 1, **attributes, cluster:) }

    let(:params) { { cluster_ids: cluster.id } }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(server) }
  end

  describe "when sorting" do
    pending "TODO"
  end
end
