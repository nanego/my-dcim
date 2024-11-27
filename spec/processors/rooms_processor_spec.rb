# frozen_string_literal: true

require "rails_helper"

RSpec.describe RoomsProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { Room.all }
  let(:params) { {} }

  describe "when searching" do
    let(:params) { { q: "wood" } }

    before do
      Room.create!(name: "brick", site: sites(:two))
      Room.create!(name: "wood", site: sites(:two))
      Room.create!(name: "wooden", site: sites(:two))
    end

    # IMPROVE
    it { expect(result.size).to eq(2) }
  end

  describe "when filtering by site_ids" do
    let(:site) { Site.create!(name: "S1") }
    let(:room) { Room.create!(name: "R1", site: site) }

    before do
      room
      Room.create!(name: "R2", site: sites(:two))
    end

    context "with one site_ids" do
      let(:params) { { site_ids: site.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(room) }
    end

    context "with many site_ids" do
      let(:site_second) { Site.create!(name: "S2") }
      let(:room_second) { Room.create!(name: "R2", site: site_second) }

      let(:params) { { site_ids: [site.id, site_second.id] } }

      before do
        room_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(room, room_second) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end
end
