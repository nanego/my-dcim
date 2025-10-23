# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChangelogEntryDecorator, type: :decorator do
  let(:object) { ChangelogEntry.new(object_type: "Color", object_changed_attributes: { id: [nil, 42] }) }
  let(:decorated_changelog_entry) { described_class.decorate(object) }

  describe ".authors_options" do
    it { expect(described_class.authors_options).to match_array(User.select(:id, :name, :email).map { |u| [u.id, u.to_s] }) }
  end

  describe ".object_types_options" do
    let(:entry_user) { ChangelogEntry.create!(object: users(:one), action: "create") }
    let(:entry_room) { ChangelogEntry.create!(object: rooms(:one), action: "create") }

    before do
      entry_user
      entry_room
    end

    it do
      expect(described_class.object_types_options).to contain_exactly(
        [User.model_name.human, User.name], [Room.model_name.human, Room.name],
      )
    end
  end

  describe "#object_link_to" do
    let(:view_context) do
      controller_class = Class.new(ActionView::TestCase::TestController)
      controller_class.new.view_context
    end

    context "with existing object" do
      let(:object) { ChangelogEntry.new(object: colors(:one)) }

      it do
        expect(decorated_changelog_entry.object_link_to(view_context))
          .to eq(%(<a href="/colors/#{object.object.id}">Couleur: ##{object.object.id}</a>))
      end
    end

    context "with destroyed object" do
      let(:object) { ChangelogEntry.new(object_type: "Color", object_id: 999_999_999) }

      it do
        expect(decorated_changelog_entry.object_link_to(view_context))
          .to eq("Couleur: #999999999")
      end
    end
  end

  describe "#object_pre_change_attributes" do
    it { expect(decorated_changelog_entry.object_pre_change_attributes).to eq({ "id" => nil }) }
  end

  describe "#object_pre_change_attributes_to_json" do
    it { expect(decorated_changelog_entry.object_pre_change_attributes_to_json).to include("id", "null") }
  end

  describe "#object_post_change_attributes" do
    it { expect(decorated_changelog_entry.object_post_change_attributes).to eq({ "id" => 42 }) }
  end

  describe "#object_post_change_attributes_to_json" do
    it { expect(decorated_changelog_entry.object_post_change_attributes_to_json).to include("id", "42") }
  end

  describe "#split_diff" do
    it { expect(decorated_changelog_entry.split_diff.left).to include("null") }
    it { expect(decorated_changelog_entry.split_diff.right).to include("42") }
  end

  describe "#object_changed_attributes_to_sentence" do
    it { expect(decorated_changelog_entry.object_changed_attributes_to_sentence).to include("Id") }
  end

  describe "#action_to_badge_component" do
    let(:object) { ChangelogEntry.new(params) }
    let(:params) { {} }

    {
      create: :success,
      update: :info,
      destroy: :danger,
      unknown: :primary,
    }.each do |action, expected_type|
      context "with #{action}" do
        let(:params) { { action: action } }

        it { expect(decorated_changelog_entry.action_to_badge_component.instance_variable_get(:@color)).to eq(expected_type) }
      end
    end
  end
end
