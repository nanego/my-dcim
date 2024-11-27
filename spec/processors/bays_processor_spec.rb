# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaysProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { Bay.all }
  let(:params) { {} }

  describe "when searching" do
    let(:params) { { q: "wood" } }

    before do
      Bay.create!(bay_type: bay_types(:one), islet: islets(:one), frames: [Frame.build(name: "brick")])
      Bay.create!(bay_type: bay_types(:one), islet: islets(:one), frames: [Frame.build(name: "wood")])
      Bay.create!(bay_type: bay_types(:one), islet: islets(:one), frames: [Frame.build(name: "wooden")])
    end

    # IMPROVE
    it { expect(result.size).to eq(2) }
  end

  describe "when filtering by room_ids" do
    let(:room) { Room.create!(name: "R1", site: sites(:one)) }
    let(:bay)  { Bay.create!(name: "bay", room: room, bay_type: bay_types(:one)) }

    before do
      bay
      Bay.create!(name: "bay2", room: rooms(:two), bay_type: bay_types(:one))
    end

    context "with one room_ids" do
      let(:params) { { room_ids: room.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(bay) }
    end

    context "with many room_ids" do
      let(:room_second) { Room.create!(name: "R1", site: sites(:one)) }
      let(:bay_second)  { Bay.create!(name: "bay", room: room_second, bay_type: bay_types(:one)) }

      let(:params) { { room_ids: [room.id, room_second.id] } }

      before do
        bay_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(bay, bay_second) }
    end
  end

  describe "when filtering by manufacturer_ids" do
    let(:manufacturer) { Manufacturer.create!(name: "M1") }
    let(:bay) { Bay.create!(name: "bay", manufacturer: manufacturer, bay_type: bay_types(:one), islet: islets(:one)) }

    before do
      bay
      Bay.create!(name: "bay2", manufacturer: manufacturers(:fortinet), bay_type: bay_types(:one), islet: islets(:one))
    end

    context "with one manufacturer_ids" do
      let(:params) { { manufacturer_ids: manufacturer.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(bay) }
    end

    context "with many manufacturer_ids" do
      let(:manufacturer_second) { Manufacturer.create!(name: "M1") }
      let(:bay_second) { Bay.create!(name: "bay", manufacturer: manufacturer_second, bay_type: bay_types(:one), islet: islets(:one)) }

      let(:params) { { manufacturer_ids: [manufacturer.id, manufacturer_second.id] } }

      before do
        bay_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(bay, bay_second) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end
end
