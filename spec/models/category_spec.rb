# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category do
  subject(:category) { described_class.new(name: "Pdu") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:modeles) }
  end

  describe "#to_s" do
    it { expect(category.to_s).to eq category.name }
  end

  describe "#pdu?" do
    it { expect(category.pdu?).to be true }
  end
end
