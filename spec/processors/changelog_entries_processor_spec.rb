# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChangelogEntriesProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { ChangelogEntry.all }
  let(:params) { {} }

  describe "when searching" do
    context "with an object id" do
      let(:one_changelog_entry) { ChangelogEntry.create!(object: users(:one), action: :update) }
      let(:two_changelog_entry) { ChangelogEntry.create!(object: users(:two), action: :update) }

      let(:params) { { q: users(:one).id.to_s } }

      before do
        one_changelog_entry
        two_changelog_entry
      end

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(one_changelog_entry) }
    end

    context "with an object name" do
      let(:one_changelog_entry) { ChangelogEntry.create!(object: users(:one), action: :update) }
      let(:two_changelog_entry) { ChangelogEntry.create!(object: users(:two), action: :update) }

      let(:params) { { q: users(:one).name.to_s } }

      before do
        one_changelog_entry
        two_changelog_entry
      end

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(one_changelog_entry) }
    end
  end

  describe "when filtering by actions" do
    let(:updated_changelog_entry) { ChangelogEntry.create!(object: sites(:one), action: :update) }
    let(:destroyed_changelog_entry) { ChangelogEntry.create!(object: sites(:one), action: :destroy) }

    before do
      updated_changelog_entry
      destroyed_changelog_entry
    end

    context "with one action" do
      let(:params) { { actions: :update } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(updated_changelog_entry) }
    end

    context "with many actions" do
      let(:params) { { actions: %i[update destroy] } }

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(updated_changelog_entry, destroyed_changelog_entry) }
    end
  end

  describe "when filtering by authors" do
    let(:one_changelog_entry) { ChangelogEntry.create!(object: sites(:one), action: :update, author: users(:one)) }
    let(:two_changelog_entry) { ChangelogEntry.create!(object: sites(:one), action: :update, author: users(:two)) }

    before do
      one_changelog_entry
      two_changelog_entry
    end

    context "with one author" do
      let(:params) { { authors: users(:one).id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(one_changelog_entry) }
    end

    context "with many authors" do
      let(:params) { { authors: [users(:one).id, users(:two).id] } }

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(one_changelog_entry, two_changelog_entry) }
    end
  end

  describe "when filtering by object types" do
    let(:site_changelog_entry) { ChangelogEntry.create!(object: sites(:one), action: :update) }
    let(:room_changelog_entry) { ChangelogEntry.create!(object: rooms(:one), action: :update) }

    before do
      site_changelog_entry
      room_changelog_entry
    end

    context "with one object type" do
      let(:params) { { object_types: :Site } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(site_changelog_entry) }
    end

    context "with many actions" do
      let(:params) { { object_types: %i[Site Room] } }

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(site_changelog_entry, room_changelog_entry) }
    end
  end

  describe "when filtering by date" do
    let(:date) { DateTime.new(2025, 10, 20, 8, 30) }
    let(:correct_date_changelog_entry) { ChangelogEntry.create!(object: sites(:one), action: :update, created_at: date) }
    let(:incorrect_date_changelog_entry) { ChangelogEntry.create!(object: rooms(:one), action: :update, created_at: date.next_day) }
    let(:params) { { date: date.to_s } }

    before do
      correct_date_changelog_entry
      incorrect_date_changelog_entry
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(correct_date_changelog_entry) }
  end
end
