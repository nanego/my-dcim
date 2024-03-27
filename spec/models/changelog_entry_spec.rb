# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangelogEntry do
  subject(:changelog_entry) { described_class.new }

  describe "validations" do
    it { is_expected.to validate_presence_of(:object_id) }
    it { is_expected.to validate_presence_of(:object_type) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:object).optional }
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
