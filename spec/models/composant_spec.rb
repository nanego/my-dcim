# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Composant, type: :model do
  subject(:composant) { Composant.new(name: "SL8") }

  describe "associations" do
    it { is_expected.to belong_to(:type_composant) }
    it { is_expected.to belong_to(:enclosure) }
    it { is_expected.to have_one(:modele).through(:enclosure) }
    it { is_expected.to have_many(:cards) }
  end

  describe "validations" do
    xit { is_expected.to be_valid }
  end

  describe "#to_s" do
    it { expect(composant.to_s).to be composant.name }
  end
end
