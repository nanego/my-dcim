# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Site do
  subject(:site) { described_class.new(name: "Site A", street: "Rue du Cactus", city: "92055 La Défense", country: "France") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:rooms) }
  end

  describe "#to_s" do
    it { expect(site.to_s).to eq site.name }
  end

  describe "#address" do
    it { expect(site.address).to eq "Rue du Cactus, 92055 La Défense, France" }
  end
end
