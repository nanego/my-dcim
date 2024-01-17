# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemoryType, type: :model do
  it_behaves_like "changelogable", new_attributes: { quantity: 2 }

  subject(:memory_type) { MemoryType.new(quantity: 1, unit: "Gb") }

  describe "associations" do
    it { is_expected.to have_many(:memory_components) }
  end

  describe "#to_s" do
    it { expect(memory_type.to_s).to eq "1Gb" }
  end
end
