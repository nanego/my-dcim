# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitsProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:pdu_attr) { { type_id: 1, bay_id: 1, orientation: :asc, side: :left, comment: "", ipmi_url: "" } }
  let(:input) { PowerDistributionUnit.all }
  let(:params) { {} }

  describe "when searching" do
    let(:params) { { q: "wood" } }

    before do
      PowerDistributionUnit.create!(name: "brick", serial_number: "101", **pdu_attr)
      PowerDistributionUnit.create!(name: "wood", serial_number: "102", **pdu_attr)
      PowerDistributionUnit.create!(name: "wooden", serial_number: "103", **pdu_attr)
    end

    it { expect(result.size).to eq(2) }
  end

  describe "when filtering by room_ids" do
    let(:room) { Room.create!(name: "R1", site: sites(:one)) }
    let(:islet) { Islet.create!(name: "I1", room:) }
    let(:bay) { Bay.create!(name: "B1", islet:, bay_type: bay_types(:one)) }
    let(:power_distribution_unit) { PowerDistributionUnit.create!(name: "PDU1", serial_number: "10", **pdu_attr, bay:) }

    before do
      power_distribution_unit
      PowerDistributionUnit.create!(name: "PDU1", serial_number: "11", **pdu_attr, bay: bays(:one))
    end

    context "with one room_ids" do
      let(:params) { { room_ids: room.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(power_distribution_unit) }
    end

    context "with many room_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:room_second) { Room.create!(name: "R2", site: sites(:one)) }
      let(:islet_second) { Islet.create!(name: "I2", room: room_second) }
      let(:bay_second) { Bay.create!(name: "B2", islet: islet_second, bay_type: bay_types(:one)) }
      let(:power_distribution_unit_second) do
        PowerDistributionUnit.create!(name: "PDU1", serial_number: "12", **pdu_attr, bay: bay_second)
      end

      let(:params) { { room_ids: [room.id, room_second.id] } }

      before do
        power_distribution_unit_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(power_distribution_unit, power_distribution_unit_second) }
    end
  end

  describe "when filtering by islet_ids" do
    let(:islet) { Islet.create!(name: "I1", room: rooms(:one)) }
    let(:bay) { Bay.create!(name: "B1", islet:, bay_type: bay_types(:one)) }
    let(:power_distribution_unit) { PowerDistributionUnit.create!(name: "PDU1", serial_number: "10", **pdu_attr, bay:) }

    before do
      power_distribution_unit
      PowerDistributionUnit.create!(name: "PDU1", serial_number: "11", **pdu_attr, bay: bays(:one))
    end

    context "with one islet_ids" do
      let(:params) { { islet_ids: islet.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(power_distribution_unit) }
    end

    context "with many islet_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:islet_second) { Islet.create!(name: "I2", room: rooms(:one)) }
      let(:bay_second) { Bay.create!(name: "B2", islet: islet_second, bay_type: bay_types(:one)) }
      let(:power_distribution_unit_second) do
        PowerDistributionUnit.create!(name: "PDU1", serial_number: "12", **pdu_attr, bay: bay_second)
      end

      let(:params) { { islet_ids: [islet.id, islet_second.id] } }

      before do
        power_distribution_unit_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(power_distribution_unit, power_distribution_unit_second) }
    end
  end

  describe "when filtering by bay_ids" do
    let(:bay) { Bay.create!(name: "B1", islet: islets(:one), bay_type: bay_types(:one)) }
    let(:power_distribution_unit) { PowerDistributionUnit.create!(name: "PDU1", serial_number: "10", **pdu_attr, bay:) }

    before do
      power_distribution_unit
      PowerDistributionUnit.create!(name: "PDU1", serial_number: "11", **pdu_attr, bay: bays(:one))
    end

    context "with one bay_ids" do
      let(:params) { { bay_ids: bay.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(power_distribution_unit) }
    end

    context "with many bay_ids" do
      let(:bay_second) { Bay.create!(name: "B2", islet: islets(:one), bay_type: bay_types(:one)) }
      let(:power_distribution_unit_second) do
        PowerDistributionUnit.create!(name: "PDU1", serial_number: "12", **pdu_attr, bay: bay_second)
      end

      let(:params) { { bay_ids: [bay.id, bay_second.id] } }

      before do
        power_distribution_unit_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(power_distribution_unit, power_distribution_unit_second) }
    end
  end

  describe "when filtering by type_ids" do
    let(:type) { PowerDistributionUnitType.create!(name: "T1", current_type: :three_phase, manufacturer: manufacturers(:fortinet)) }
    let(:power_distribution_unit) { PowerDistributionUnit.create!(name: "PDU1", serial_number: "10", **pdu_attr, type:) }

    before do
      power_distribution_unit
      PowerDistributionUnit.create!(name: "PDU1", serial_number: "11", **pdu_attr, type: power_distribution_unit_types(:one))
    end

    context "with one type_ids" do
      let(:params) { { type_ids: type.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(power_distribution_unit) }
    end

    context "with many type_ids" do
      let(:type_second) { PowerDistributionUnitType.create!(name: "T2", current_type: :three_phase, manufacturer: manufacturers(:fortinet)) }
      let(:power_distribution_unit_second) { PowerDistributionUnit.create!(name: "PDU1", serial_number: "12", **pdu_attr, type: type_second) }

      let(:params) { { type_ids: [type.id, type_second.id] } }

      before do
        power_distribution_unit_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(power_distribution_unit, power_distribution_unit_second) }
    end
  end

  describe "when filtering by manufacturer_ids" do
    let(:manufacturer) { Manufacturer.create!(name: "M1") }
    let(:type) { PowerDistributionUnitType.create!(name: "T1", current_type: :three_phase, manufacturer:) }
    let(:power_distribution_unit) { PowerDistributionUnit.create!(name: "PDU1", serial_number: "10", **pdu_attr, type:) }

    before do
      power_distribution_unit
      PowerDistributionUnit.create!(name: "PDU1", serial_number: "11", **pdu_attr, type: power_distribution_unit_types(:one))
    end

    context "with one manufacturer_ids" do
      let(:params) { { manufacturer_ids: manufacturer.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(power_distribution_unit) }
    end

    context "with many manufacturer_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:manufacturer_second) { Manufacturer.create!(name: "M1") }
      let(:type_second) { PowerDistributionUnitType.create!(name: "T1", current_type: :three_phase, manufacturer: manufacturer_second) }
      let(:power_distribution_unit_second) do
        PowerDistributionUnit.create!(name: "PDU1", serial_number: "12", **pdu_attr, type: type_second)
      end

      let(:params) { { manufacturer_ids: [manufacturer.id, manufacturer_second.id] } }

      before do
        power_distribution_unit_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(power_distribution_unit, power_distribution_unit_second) }
    end
  end

  describe "When searching on every fields" do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:room)     { Room.create(name: "R1", site: sites(:one)) }
    let(:islet)    { Islet.create!(name: "I1", room:) }
    let(:bay)      { Bay.create!(name: "A1", islet:, bay_type: bay_types(:one)) }
    let(:manufacturer) { Manufacturer.create! }
    let(:type) { PowerDistributionUnitType.create!(name: "T1", current_type: :three_phase, manufacturer:) }

    let(:power_distribution_unit) do
      PowerDistributionUnit.create!(name: "wood", serial_number: 1, **pdu_attr, type:, bay:)
    end

    let(:params) do
      {
        q: "wood", room_ids: room.id, islet_ids: islet.id, bay_ids: bay.id,
        type_ids: type.id, manufacturer_ids: manufacturer.id,
      }
    end

    before { power_distribution_unit }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(power_distribution_unit) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "and sort on #{field}" do # rubocop:disable RSpec/ContextWording, RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            q: "wood", room_ids: room.id, islet_ids: islet.id, bay_ids: bay.id,
            manufacturer_ids: manufacturer.id, type_ids: type.id,
            sort_by: field,
          }
        end

        it { expect(result.size).to eq(1) }
        it { is_expected.to contain_exactly(power_distribution_unit) }
      end
    end
  end

  describe "when sorting" do
    pending "TODO"
  end
end
