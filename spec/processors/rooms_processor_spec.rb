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

  describe "when filtering by site_id" do
    let(:site) { Site.create!(name: "S1") }
    let(:room) { Room.create!(name: "R1", site: site) }

    let(:params) { { site_id: site.id } }

    before do
      room
      Room.create!(name: "R2", site: sites(:two))
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(room) }
  end

  describe "when sorting" do
    pending "TODO"
  end
end
