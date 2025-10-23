# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserDecorator, type: :decorator do
  let(:user) { users(:one) }
  let(:decorated_user) { user.decorated }

  describe ".available_locales_options_for_select" do
    it { expect(described_class.available_locales_options_for_select.pluck(1)).to match_array(User::AVAILABLE_LOCALES) }
  end

  describe ".available_themes_options_for_select" do
    it { expect(described_class.available_themes_options_for_select.pluck(1)).to match_array(User::AVAILABLE_THEMES) }
  end

  describe ".available_background_colors_options_for_select" do
    it { expect(described_class.available_background_colors_options_for_select.pluck(1)).to match_array(User::AVAILABLE_BAY_BACKGROUND_COLORS) }
  end

  describe ".available_bay_orientations_options_for_select" do
    it { expect(described_class.available_bay_orientations_options_for_select.pluck(1)).to match_array(User::AVAILABLE_BAY_ORIENTATIONS) }
  end

  describe "#role_human_name" do
    context "when role is reader" do
      let(:user) { users(:reader) }

      it { expect(decorated_user.role_human_name).to eq(User.human_attribute_name("role.reader")) }
    end

    context "when role is writer" do
      let(:user) { users(:writer) }

      it { expect(decorated_user.role_human_name).to eq(User.human_attribute_name("role.writer")) }
    end
  end

  describe "#role_to_badge_component" do
    subject(:badge) { decorated_user.role_to_badge_component }

    context "when role is admin" do
      let(:user) { users(:admin) }

      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :warning }
      it { expect(badge.content).to eq "Admin" }
    end

    context "when role is reader" do
      let(:user) { users(:reader) }

      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :info }
      it { expect(badge.content).to eq "Lecteur" }
    end

    context "when role is writer" do
      let(:user) { users(:writer) }

      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :primary }
      it { expect(badge.content).to eq "Éditeur" }
    end
  end
end
