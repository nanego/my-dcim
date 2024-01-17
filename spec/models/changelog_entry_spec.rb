# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangelogEntry, type: :model do
  subject(:changelog_entry) { ChangelogEntry.new }

  describe "associations" do
    it { is_expected.to belong_to(:object) }
    it { is_expected.to belong_to(:author).optional }
  end

  describe "#object_display_name" do
    pending "TODO"
  end

  describe "#object_type_name" do
    pending "TODO"
  end

  describe "#author_display_name" do
    pending "TODO"
  end

  describe "#author_type_name" do
    pending "TODO"
  end

  describe "#object_pre_change_attributes" do
    pending "TODO"
  end

  describe "#object_pre_change_attributes_to_json" do
    pending "TODO"
  end

  describe "#object_post_change_attributes" do
    pending "TODO"
  end

  describe "#object_post_change_attributes_to_json" do
    pending "TODO"
  end

  describe "#split_diff" do
    pending "TODO"
  end

  describe "#action_label_to_component" do
    pending "TODO"
  end
end
