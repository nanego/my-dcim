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
    it { is_expected.to include(frame) }
  end

  describe "when filtering by room_id" do
    let(:room)  { Room.create!(name: "R1", site: sites(:one)) }
    let(:bay)   { Bay.create!(name: "bay", room: room, bay_type: bay_types(:one)) }
    let(:frame) { Frame.create!(name: "frame", bay: bay) }

    let(:params) { { room_id: room.id } }

    before do
      frame
      Frame.create!(name: "frame2", bay: bays(:one))
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(frame) }
  end

  describe "when filtering by islet_id" do
    let(:islet) { Islet.create!(name: "I1", site: sites(:one)) }
    let(:bay)   { Bay.create!(name: "bay", islet: islet, bay_type: bay_types(:one)) }
    let(:frame) { Frame.create!(name: "frame", bay: bay) }

    let(:params) { { islet_id: islet.id } }

    before do
      frame
      Frame.create!(name: "frame2", bay: bays(:one))
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(frame) }
  end

  describe "when sorting" do
    pending "TODO"
  end
end
