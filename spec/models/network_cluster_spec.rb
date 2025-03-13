# frozen_string_literal: true

require "rails_helper"

RSpec.describe NetworkCluster do
  subject(:network_cluster) { described_class.new(room:, network_types:) }

  let(:room) { rooms(:room_with_network_cluster_gbe) }
  let(:network_types) { %i[gbe] }

  describe "#servers" do
    it do
      expect(network_cluster.servers)
        .to contain_exactly(servers(:hub_network1), servers(:hub_network2))
    end
  end

  describe "#room_server" do
    it { expect(network_cluster.room_server).to eq(servers(:hub_network1)) }
  end

  describe "#other_rooms_servers" do
    it { expect(network_cluster.other_rooms_servers).to contain_exactly(servers(:hub_network2)) }
  end
end
