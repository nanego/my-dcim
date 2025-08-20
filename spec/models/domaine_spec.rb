# frozen_string_literal: true

require "rails_helper"

RSpec.describe Domaine do
  subject(:domaine) { described_class.new(name: "Eco") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:servers) }
  end

  describe "#to_s" do
    it { expect(described_class.to_s).to eq described_class.name }
  end
end
