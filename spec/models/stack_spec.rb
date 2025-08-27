# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stack do
  subject(:stack) { described_class.new(name: "Rouge") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:servers) }
  end

  describe "#to_s" do
    it { expect(stack.to_s).to eq stack.name }
  end
end
