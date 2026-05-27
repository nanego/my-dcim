# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitTypesProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { PowerDistributionUnitType.all }
  let(:params) { {} }

  describe "when searching" do
    let(:params) { { q: "wood" } }

    before do
      PowerDistributionUnitType.create!(name: "brick", current_type: :three_phase, manufacturer: manufacturers(:fortinet))
      PowerDistributionUnitType.create!(name: "wood", current_type: :three_phase, manufacturer: manufacturers(:fortinet))
      PowerDistributionUnitType.create!(name: "wooden", current_type: :three_phase, manufacturer: manufacturers(:fortinet))
    end

    it { expect(result.size).to eq(2) }
  end

  describe "when filtering by manufacturer_ids" do
    let(:manufacturer) { Manufacturer.create!(name: "M1") }
    let(:power_distribution_unit_type) { PowerDistributionUnitType.create!(name: "PDUType1", current_type: :three_phase, manufacturer:) }

    before do
      power_distribution_unit_type
      PowerDistributionUnitType.create!(name: "PDUType2", current_type: :three_phase, manufacturer: manufacturers(:juniper))
    end

    context "with one manufacturer_ids" do
      let(:params) { { manufacturer_ids: manufacturer.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(power_distribution_unit_type) }
    end

    context "with many site_ids" do
      let(:manufacturer_second) { Manufacturer.create!(name: "M2") }
      let(:power_distribution_unit_type_second) do
        PowerDistributionUnitType.create!(name: "PDUType2", current_type: :three_phase, manufacturer: manufacturer_second)
      end

      let(:params) { { manufacturer_ids: [manufacturer.id, manufacturer_second.id] } }

      before do
        power_distribution_unit_type_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(power_distribution_unit_type, power_distribution_unit_type_second) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end
end
