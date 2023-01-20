# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cluster, type: :model do
  let(:cluster) { Cluster.create(name: "Cloud-C5") }

  describe "associations" do
    it { is_expected.to have_many(:servers) }
  end

  describe "#to_s" do
    it { expect(cluster.to_s).to eq cluster.name }
  end
end
