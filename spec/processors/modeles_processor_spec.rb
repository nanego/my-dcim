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

  describe "when filtering by architecture_ids" do
    let(:architecture) { Architecture.create!(name: "A1") }
    let(:modele) { Modele.create!(name: "modele", **attributes, architecture:) }

    let(:params) { { architecture_ids: architecture.id } }

    before do
      modele
      Modele.create!(name: "modele2", **attributes)
    end

    context "with one architecture_ids" do
      let(:params) { { architecture_ids: architecture.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(modele) }
    end

    context "with many architecture_ids" do
      let(:architecture_second) { Architecture.create!(name: "A2") }
      let(:modele_second) { Modele.create!(name: "modele", **attributes, architecture: architecture_second) }

      let(:params) { { architecture_ids: [architecture.id, architecture_second.id] } }

      before do
        modele_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(modele, modele_second) }
    end
  end

  describe "when filtering by category_ids" do
    let(:category) { Category.create!(name: "C1") }
    let(:modele) { Modele.create!(name: "modele", **attributes, category:) }

    before do
      modele
      Modele.create!(name: "modele2", **attributes)
    end

    context "with one category_ids" do
      let(:params) { { category_ids: category.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(modele) }
    end

    context "with many category_ids" do
      let(:category_second) { Category.create!(name: "C2") }
      let(:modele_second) { Modele.create!(name: "modele", **attributes, category: category_second) }

      let(:params) { { category_ids: [category.id, category_second.id] } }

      before do
        modele_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(modele, modele_second) }
    end
  end

  describe "when filtering by manufacturer_ids" do
    let(:manufacturer) { Manufacturer.create!(name: "M1") }
    let(:modele) { Modele.create!(name: "modele", **attributes, manufacturer:) }

    before do
      modele
      Modele.create!(name: "modele2", **attributes)
    end

    context "with one manufacturer_ids" do
      let(:params) { { manufacturer_ids: manufacturer.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(modele) }
    end

    context "with many manufacturer_ids" do
      let(:manufacturer_second) { Manufacturer.create!(name: "M2") }
      let(:modele_second) { Modele.create!(name: "modele", **attributes, manufacturer: manufacturer_second) }

      let(:params) { { manufacturer_ids: [manufacturer.id, manufacturer_second.id] } }

      before do
        modele_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(modele, modele_second) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end
end
