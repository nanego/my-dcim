# frozen_string_literal: true

require "rails_helper"

RSpec.describe IsletsProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { Islet.all }
  let(:params) { {} }

  describe "when searching" do
    let(:params) { { q: "wood" } }

    before do
      Islet.create!(name: "brick", room: rooms(:one))
      Islet.create!(name: "wood", room: rooms(:one))
      Islet.create!(name: "wooden", room: rooms(:one))
    end

    # IMPROVE
    it { expect(result.size).to eq(2) }
  end

  describe "when filtering by room_id" do
    let(:room)  { Room.create!(name: "R1", site: sites(:one)) }
    let(:islet) { Islet.create!(name: "islet", room: room) }

    let(:params) { { room_id: room.id } }

    before do
      islet
      Islet.create!(name: "islet2", room: rooms(:one))
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(islet) }
  end

  describe "when filtering by site_id" do
    let(:site) { Site.create!(name: "Site1") }
    let(:room)  { Room.create!(name: "R1", site: site) }
    let(:islet) { Islet.create!(name: "islet", room: room) }

    let(:params) { { site_id: site.id } }

    before do
      islet
      Islet.create!(name: "islet2", room: rooms(:one))
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(islet) }
  end

  describe "when sorting" do
    pending "TODO"
  end
end
