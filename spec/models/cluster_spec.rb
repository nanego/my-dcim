# frozen_string_literal: true

require "rails_helper"

RSpec.describe Cluster do
  subject(:cluster) { described_class.new(name: "Cloud-C5") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:servers) }
  end

  describe "#to_s" do
    it { expect(cluster.to_s).to eq cluster.name }
  end
end
