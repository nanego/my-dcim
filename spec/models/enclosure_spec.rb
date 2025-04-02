# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Enclosure do
  # it_behaves_like "changelogable", new_attributes: { display: "New value" }

  describe "associations" do
    it { is_expected.to belong_to(:modele) }
    it { is_expected.to have_many(:composants).dependent(:destroy) }
  end

  describe "#deep_dup" do
    subject(:enclosure) { enclosures(:one) }

    it { expect(enclosure.deep_dup).not_to eq(enclosure) }
    it { expect(enclosure.deep_dup.position).to eq(enclosure.position) }
    it { expect(enclosure.deep_dup.composants.size).to eq(enclosure.composants.size) }
  end
end
