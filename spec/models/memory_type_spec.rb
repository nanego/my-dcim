# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemoryType do
  subject(:memory_type) { described_class.new(quantity: 1, unit: "Gb") }

  it_behaves_like "changelogable", new_attributes: { quantity: 2 }

  describe "associations" do
    it { is_expected.to have_many(:memory_components) }
  end

  describe "#to_s" do
    it { expect(memory_type.to_s).to eq "1Gb" }
  end
end
