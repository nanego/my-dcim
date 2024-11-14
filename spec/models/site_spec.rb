# frozen_string_literal: true

require "rails_helper"

RSpec.describe Site do
  subject(:site) do
    described_class.new(name: "Site A", street: "Rue du Cactus", city: "92055 La Défense", country: "France")
  end

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:rooms) }
    it { is_expected.to have_many(:frames).through(:rooms) }
    it { is_expected.to have_many(:contact_assignments) }
  end

  describe "validations" do
    it do
      is_expected.to validate_content_type_of(:delivery_map).allowing("image/png", # rubocop:disable RSpec/ImplicitSubject
                                                                      "image/jpeg",
                                                                      "image/gif",
                                                                      "application/pdf")
    end
  end

  describe "#to_s" do
    it { expect(site.to_s).to eq site.name }
  end

  describe "#address" do
    it { expect(site.address).to eq "Rue du Cactus, 92055 La Défense, France" }
  end
end
