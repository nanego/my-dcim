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

  describe "when filtering by room_id" do
    let(:room) { Room.create!(name: "R1", site: sites(:one)) }
    let(:bay)  { Bay.create!(name: "bay", room: room, bay_type: bay_types(:one)) }

    let(:params) { { room_id: room.id } }

    before do
      bay
      Bay.create!(name: "bay2", room: rooms(:two), bay_type: bay_types(:one))
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(bay) }
  end

  describe "when sorting" do
    pending "TODO"
  end
end
