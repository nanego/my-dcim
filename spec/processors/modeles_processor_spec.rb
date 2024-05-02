# frozen_string_literal: true

require "rails_helper"

RSpec.describe ModelesProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { Modele.all }
  let(:params) { {} }

  let(:attributes) do
    { manufacturer: manufacturers(:fortinet), architecture: architectures(:rackable), category: categories(:one) }
  end

  describe "when searching" do
    let(:params) { { q: "wood" } }

    before do
      Modele.create!(name: "brick", **attributes)
      Modele.create!(name: "wood", **attributes)
      Modele.create!(name: "wooden", **attributes)
    end

    # IMPROVE
    it { expect(result.size).to eq(2) }
  end

  describe "when filtering by architecture_id" do
    let(:architecture) { Architecture.create!(name: "A1") }
    let(:modele) { Modele.create!(name: "modele", **attributes, architecture:) }

    let(:params) { { architecture_id: architecture.id } }

    before do
      modele
      Modele.create!(name: "modele2", **attributes)
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(modele) }
  end

  describe "when filtering by category_id" do
    let(:category) { Category.create!(name: "C1") }
    let(:modele) { Modele.create!(name: "modele", **attributes, category:) }

    let(:params) { { category_id: category.id } }

    before do
      modele
      Modele.create!(name: "modele2", **attributes)
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(modele) }
  end

  describe "when filtering by manufacturer_id" do
    let(:manufacturer) { Manufacturer.create!(name: "C1") }
    let(:modele) { Modele.create!(name: "modele", **attributes, manufacturer:) }

    let(:params) { { manufacturer_id: manufacturer.id } }

    before do
      modele
      Modele.create!(name: "modele2", **attributes)
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(modele) }
  end

  describe "when sorting" do
    pending "TODO"
  end
end
