# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Composant do
  # it_behaves_like "changelogable", object: -> { described_class.new(type_composant: TypeComposant.create!) },
  #                                  new_attributes: { name: "New name" }

  subject(:composant) { described_class.new(name: "SL8") }

  describe "associations" do
    it { is_expected.to belong_to(:enclosure) }
    it { is_expected.to have_one(:modele).through(:enclosure) }
    it { is_expected.to have_many(:cards) }
  end

  describe "validations" do
    xit { is_expected.to be_valid }

    describe "name format" do
      before { composant.valid? }

      context "with valid name" do
        subject(:composant) { described_class.new(name: "validname") }

        it { expect(composant.errors.where(:name, :invalid).count).to eq(0) }
      end

      context "with empty name" do
        subject(:composant) { described_class.new(name: "invalid name") }

        it { expect(composant.errors.where(:name, :invalid).count).to eq(1) }
      end
    end
  end

  describe "#to_s" do
    it { expect(composant.to_s).to be composant.name }
  end
end
