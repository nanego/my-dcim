# frozen_string_literal: true

require "rails_helper"

RSpec.describe FramesProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { Frame.all }
  let(:params) { {} }

  describe "when searching" do
    let(:params) { { q: "wood" } }

    before do
      Frame.create!(name: "brick", bay: bays(:one))
      Frame.create!(name: "wood", bay: bays(:one))
      Frame.create!(name: "wooden", bay: bays(:one))
    end

    # IMPROVE
    it { expect(result.size).to eq(2) }
  end

  describe "when filtering by u" do
    let(:frame) { Frame.create!(name: "frame", u: "1", bay: bays(:one)) }

    let(:params) { { u: 1 } }

    before do
      frame
      Frame.create!(name: "frame2", u: "2", bay: bays(:one))
      Frame.create!(name: "frame3", u: "3", bay: bays(:one))
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(frame) }
  end

  describe "when filtering by room_ids" do
    let(:room)  { Room.create!(name: "R1", site: sites(:one)) }
    let(:bay)   { Bay.create!(name: "B1", room: room, bay_type: bay_types(:one)) }
    let(:frame) { Frame.create!(name: "F1", bay: bay) }

    before do
      frame
      Frame.create!(name: "frame2", bay: bays(:one))
    end

    context "with one room_ids" do
      let(:params) { { room_ids: room.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(frame) }
    end

    context "with many room_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:room_second)  { Room.create!(name: "R2", site: sites(:one)) }
      let(:bay_second)   { Bay.create!(name: "B2", room: room_second, bay_type: bay_types(:one)) }
      let(:frame_second) { Frame.create!(name: "F2", bay: bay_second) }

      let(:params) { { room_ids: [room.id, room_second.id] } }

      before do
        frame_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(frame, frame_second) }
    end
  end

  describe "when filtering by islet_ids" do
    let(:islet) { Islet.create!(name: "I1", site: sites(:one)) }
    let(:bay)   { Bay.create!(name: "B1", islet: islet, bay_type: bay_types(:one)) }
    let(:frame) { Frame.create!(name: "F1", bay: bay) }

    before do
      frame
      Frame.create!(name: "frame2", bay: bays(:one))
    end

    context "with one islet_ids" do
      let(:params) { { islet_ids: islet.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(frame) }
    end

    context "with many islet_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:islet_second) { Islet.create!(name: "I2", site: sites(:one)) }
      let(:bay_second)   { Bay.create!(name: "B2", islet: islet_second, bay_type: bay_types(:one)) }
      let(:frame_second) { Frame.create!(name: "F2", bay: bay_second) }

      let(:params) { { islet_ids: [islet.id, islet_second.id] } }

      before do
        frame_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(frame, frame_second) }
    end
  end

  describe "when filtering by bay_ids" do
    let(:islet) { Islet.create!(name: "I1", site: sites(:one)) }
    let(:bay)   { Bay.create!(name: "B1", islet:, bay_type: bay_types(:one)) }
    let(:frame) { Frame.create!(name: "F1", bay:) }

    before do
      frame
      Frame.create!(name: "frame2", bay: bays(:one))
    end

    context "with one bay_ids" do
      let(:params) { { bay_ids: bay.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(frame) }
    end

    context "with many bay_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:islet_second) { Islet.create!(name: "I2", site: sites(:one)) }
      let(:bay_second)   { Bay.create!(name: "B2", islet: islet_second, bay_type: bay_types(:one)) }
      let(:frame_second) { Frame.create!(name: "F2", bay: bay_second) }

      let(:params) { { bay_ids: [bay.id, bay_second.id] } }

      before do
        frame_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(frame, frame_second) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end

  describe "When searching on every fields" do
    let(:room)  { Room.create!(name: "R1", site: sites(:one)) }
    let(:islet) { Islet.create!(name: "I1", room:) }
    let(:bay)   { Bay.create!(name: "B1", islet:, bay_type: bay_types(:one)) }
    let(:frame) { Frame.create!(name: "wood", u: 2, bay:) }

    let(:params) { { q: "wood", u: 2, room_ids: room.id, islet_ids: islet.id, bay_ids: bay.id } }

    before { frame }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(frame) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "and sort on #{field}" do # rubocop:disable RSpec/ContextWording
        let(:params) { { q: "wood", u: 2, room_ids: room.id, islet_ids: islet.id, bay_ids: bay.id, sort_by: field } }

        it { expect(result.size).to eq(1) }
        it { is_expected.to contain_exactly(frame) }
      end
    end
  end
end
