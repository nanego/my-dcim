# frozen_string_literal: true

require "rails_helper"

RSpec.describe AirConditionerModelsProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { AirConditionerModel.all }
  let(:params) { {} }

  let(:attributes) do
    { manufacturer: manufacturers(:fortinet) }
  end

  describe "when searching" do
    let(:manufacturer) { manufacturers(:fortinet) }
    let(:params) { { q: "wood" } }

    before do
      AirConditionerModel.create!(name: "brick", manufacturer:)
      AirConditionerModel.create!(name: "wood", manufacturer:)
      AirConditionerModel.create!(name: "wooden", manufacturer:)
    end

    # IMPROVE
    it { expect(result.size).to eq(2) }
  end

  describe "when sorting" do
    pending "TODO"
  end

  describe "when filtering by manufacturer_ids" do
    let(:manufacturer) { Manufacturer.create!(name: "M1") }
    let(:acm) { AirConditionerModel.create!(name: "acm", **attributes, manufacturer:) }

    before do
      acm
      AirConditionerModel.create!(name: "acm2", **attributes)
    end

    context "with one manufacturer_ids" do
      let(:params) { { manufacturer_ids: manufacturer.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(acm) }
    end

    context "with many manufacturer_ids" do
      let(:manufacturer_second) { Manufacturer.create!(name: "M2") }
      let(:acm_second) { AirConditionerModel.create!(name: "acm", **attributes, manufacturer: manufacturer_second) }

      let(:params) { { manufacturer_ids: [manufacturer.id, manufacturer_second.id] } }

      before do
        acm_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(acm, acm_second) }
    end
  end

  describe "When searching on every fields" do
    let(:manufacturer) { manufacturers(:fortinet) }
    let(:air_conditioner_model) { AirConditionerModel.create!(name: "wood", manufacturer:) }

    let(:params) { { q: "wood" } }

    before { air_conditioner_model }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(air_conditioner_model) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "and sort on #{field}" do # rubocop:disable RSpec/ContextWording
        let(:params) { { q: "wood", sort_by: field } }

        it { expect(result.size).to eq(1) }
        it { is_expected.to contain_exactly(air_conditioner_model) }
      end
    end
  end
end
