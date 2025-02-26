# frozen_string_literal: true

require "rails_helper"

RSpec.describe AirConditionersProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { AirConditioner.all }
  let(:params) { {} }

  describe "when searching" do
    let(:bay) { bays(:one) }
    let(:air_conditioner_model) { air_conditioner_models(:one) }

    let(:params) { { q: "wood" } }

    before do
      AirConditioner.create!(name: "brick", bay:, air_conditioner_model:, status: :on, position: :left)
      AirConditioner.create!(name: "wood", bay:, air_conditioner_model:, status: :on, position: :left)
      AirConditioner.create!(name: "wooden", bay:, air_conditioner_model:, status: :on, position: :left)
    end

    # IMPROVE
    it { expect(result.size).to eq(2) }
  end

  describe "when filtering by room_ids" do
    let(:room) { Room.create!(name: "A", site: sites(:one)) }
    let(:bay)  { Bay.create!(room: room, bay_type: bay_types(:one)) }
    let(:air_conditioner) do
      AirConditioner.create!(
        bay: bay, air_conditioner_model: air_conditioner_models(:one), status: :on, position: :left
      )
    end

    before do
      air_conditioner
      AirConditioner.create!(
        bay: bays(:one), air_conditioner_model: air_conditioner_models(:one), status: :on, position: :left
      )
    end

    context "with one room_ids" do
      let(:params) { { room_ids: room.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(air_conditioner) }
    end

    context "with many room_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:room_second) { Room.create!(name: "B", site: sites(:two)) }
      let(:bay_second)  { Bay.create!(room: room, bay_type: bay_types(:one)) }
      let(:air_conditioner_second) do
        AirConditioner.create!(
          bay: bay_second, air_conditioner_model: air_conditioner_models(:one), status: :on, position: :left
        )
      end

      let(:params) { { room_ids: [room.id, room_second.id] } }

      before do
        air_conditioner_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(air_conditioner, air_conditioner_second) }
    end
  end

  describe "when filtering by islet_ids" do
    let(:islet) { Islet.create!(name: "I1", room: rooms(:one)) }
    let(:bay)   { Bay.create!(islet: islet, bay_type: bay_types(:one)) }
    let(:air_conditioner) do
      AirConditioner.create!(
        bay: bay, air_conditioner_model: air_conditioner_models(:one), status: :on, position: :left
      )
    end

    before do
      air_conditioner
      AirConditioner.create!(
        bay: bays(:one), air_conditioner_model: air_conditioner_models(:one), status: :on, position: :left
      )
    end

    context "with one islet_ids" do
      let(:params) { { islet_ids: islet.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(air_conditioner) }
    end

    context "with many islet_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:islet_second) { Islet.create!(name: "I2", room: rooms(:two)) }
      let(:bay_second)   { Bay.create!(islet: islet_second, bay_type: bay_types(:one)) }
      let(:air_conditioner_second) do
        AirConditioner.create!(
          bay: bay_second, air_conditioner_model: air_conditioner_models(:one), status: :on, position: :left
        )
      end

      let(:params) { { islet_ids: [islet.id, islet_second.id] } }

      before do
        air_conditioner_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(air_conditioner, air_conditioner_second) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end

  describe "When searching on every fields" do
    let(:room)  { Room.create!(name: "A", site: sites(:one)) }
    let(:islet) { Islet.create!(name: "I1", room:) }
    let(:bay)   { Bay.create!(islet:, bay_type: bay_types(:one)) }
    let(:air_conditioner) do
      AirConditioner.create!(
        name: "wood", bay:, air_conditioner_model: air_conditioner_models(:one), status: :on, position: :left
      )
    end

    let(:params) { { q: "wood", room_ids: room.id, islet_ids: islet.id } }

    before { air_conditioner }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(air_conditioner) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "and sort on #{field}" do # rubocop:disable RSpec/ContextWording
        let(:params) { { q: "wood", room_ids: room.id, islet_ids: islet.id, sort_by: field } }

        it { expect(result.size).to eq(1) }
        it { is_expected.to contain_exactly(air_conditioner) }
      end
    end
  end
end
