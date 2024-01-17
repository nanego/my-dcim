# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Domaine, type: :model do
  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  subject(:domaine) { Domaine.new(name: "Eco") }

  describe "associations" do
    it { is_expected.to have_many(:servers) }
  end

  describe "#to_s" do
    it { expect(Domaine.to_s).to eq Domaine.name }
  end
end
