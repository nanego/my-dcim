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

  describe "when filtering by room_ids" do
    let(:room)  { Room.create!(name: "R1", site: sites(:one)) }
    let(:islet) { Islet.create!(name: "I1", room: room) }

    before do
      islet
      Islet.create!(name: "islet2", room: rooms(:one))
    end

    context "with one room_ids" do
      let(:params) { { room_ids: room.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(islet) }
    end

    context "with many room_ids" do
      let(:room_second)  { Room.create!(name: "R2", site: sites(:one)) }
      let(:islet_second) { Islet.create!(name: "I2", room: room_second) }

      let(:params) { { room_ids: [room.id, room_second.id] } }

      before do
        islet_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(islet, islet_second) }
    end
  end

  describe "when filtering by site_id" do
    let(:site) { Site.create!(name: "Site1") }
    let(:room)  { Room.create!(name: "R1", site: site) }
    let(:islet) { Islet.create!(name: "I1", room: room) }

    before do
      islet
      Islet.create!(name: "islet2", room: rooms(:one))
    end

    context "with one site_ids" do
      let(:params) { { site_ids: site.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(islet) }
    end

    context "with many site_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:site_second) { Site.create!(name: "Site2") }
      let(:room_second)  { Room.create!(name: "R2", site: site_second) }
      let(:islet_second) { Islet.create!(name: "I2", room: room_second) }

      let(:params) { { site_ids: [site.id, site_second.id] } }

      before do
        islet_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(islet, islet_second) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end

  describe "When searching on every fields" do
    let(:site) { Site.create!(name: "Site1") }
    let(:room)  { Room.create!(name: "R1", site:) }
    let(:islet) { Islet.create!(name: "wood", room:) }

    let(:params) { { q: "wood", room_ids: room.id, site_ids: site.id } }

    before { islet }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(islet) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "and sort on #{field}" do # rubocop:disable RSpec/ContextWording
        let(:params) { { q: "wood", room_ids: room.id, site_ids: site.id, sort_by: field } }

        it { expect(result.size).to eq(1) }
        it { is_expected.to contain_exactly(islet) }
      end
    end
  end
end
