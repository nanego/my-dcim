# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Manufacturer do
  subject(:manufacturer) { described_class.new(name: "BULL") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:modeles) }
    it { is_expected.to have_many(:bays) }
  end

  describe "#to_s" do
    it { expect(manufacturer.to_s).to eq manufacturer.name }
  end
end
