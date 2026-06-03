# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitType do
  it_behaves_like "changelogable", object: -> { described_class.new(name: "name", manufacturer: manufacturers(:fortinet), current_type: :three_phase) },
                                   new_attributes: { name: "new name" }

  describe "associations" do
    it { is_expected.to belong_to(:manufacturer) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to define_enum_for(:current_type).with_values(%i[three_phase single_phase]) }

    describe "documentation_url format" do
      before { composant.valid? }

      describe "with empty documentation_url" do
        subject(:composant) { described_class.new(documentation_url: "") }

        it { expect(composant.errors.where(:name, :invalid).count).to eq(0) }
      end

      describe "with valid documentation_url" do
        subject(:composant) { described_class.new(documentation_url: "http://exemple.com/doc/1") }

        it { expect(composant.errors.where(:name, :invalid).count).to eq(0) }
      end

      describe "with invalid documentation_url" do
        subject(:composant) { described_class.new(documentation_url: "some invalid url") }

        it { expect(composant.errors.where(:documentation_url, :invalid).count).to eq(1) }
      end
    end
  end
end
