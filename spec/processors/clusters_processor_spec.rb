# frozen_string_literal: true

require "rails_helper"

RSpec.describe ClustersProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { Cluster.all }
  let(:params) { {} }

  describe "when searching" do
    let(:params) { { q: "wood" } }

    before do
      Cluster.create!(name: "brick")
      Cluster.create!(name: "wood")
      Cluster.create!(name: "wooden")
    end

    # IMPROVE
    it { expect(result.size).to eq(2) }
  end

  describe "when sorting" do
    let!(:cluster_a) { Cluster.create!(name: "A") }
    let!(:cluster_z) { Cluster.create!(name: "z") }

    before do
      cluster_a
      cluster_z
    end

    context "with sort by name asc" do
      let(:params) { { sort_by: :name, sort: :asc } }

      it { expect(result.first).to eq(cluster_a) }
      it { expect(result.last).to eq(cluster_z) }
    end

    context "with sort by name desc" do
      let(:params) { { sort_by: :name, sort: :desc } }

      it { expect(result.first).to eq(cluster_z) }
      it { expect(result.last).to eq(cluster_a) }
    end

    context "with sort by servers_count asc" do
      pending
    end

    context "with sort by servers_count desc" do
      pending
    end
  end

  describe "When searching on every fields" do
    let!(:cluster) { Cluster.create!(name: "wood") }

    let(:params) { { q: "wood" } }

    before { cluster }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(cluster) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "and sort on #{field}" do # rubocop:disable RSpec/ContextWording
        let(:params) { { q: "wood", sort_by: field } }

        it { expect(result.size).to eq(1) }
        it { is_expected.to contain_exactly(cluster) }
      end
    end
  end
end
