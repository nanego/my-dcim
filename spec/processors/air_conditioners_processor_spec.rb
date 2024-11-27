# frozen_string_literal: true

require "rails_helper"

RSpec.describe AirConditionersProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { AirConditioner.all }
  let(:params) { {} }

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
    let(:islet) { Islet.create!(name: "S1", room: rooms(:one)) }
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
      let(:islet_second) { Islet.create!(name: "S2", room: rooms(:two)) }
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
end
