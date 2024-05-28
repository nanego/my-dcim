# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangelogEntryDecorator, type: :decorator do
  let(:object) { ChangelogEntry.new(object_type: "colors", object_changed_attributes: { id: [nil, 42] }) }
  let(:decorated_changelog_entry) { described_class.decorate(object) }

  describe '#object_pre_change_attributes' do
    it { expect(decorated_changelog_entry.object_pre_change_attributes).to eq({ "id" => nil }) }
  end

  describe '#object_pre_change_attributes_to_json' do
    it { expect(decorated_changelog_entry.object_pre_change_attributes_to_json).to include("id", "null") }
  end

  describe '#object_post_change_attributes' do
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

  describe "#action_label_to_component" do
    let(:object) { ChangelogEntry.new(params) }
    let(:params) { {} }

    {
      create: :success,
      update: :info,
      destroy: :danger,
      unknown: :default
    }.each do |action, expected_type|
      context "with #{action}" do
        let(:params) { { action: action } }

        it { expect(decorated_changelog_entry.action_label_to_component.instance_variable_get(:@type)).to eq(expected_type) }
      end
    end
  end
end
