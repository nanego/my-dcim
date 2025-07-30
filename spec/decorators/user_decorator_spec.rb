# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDecorator, type: :decorator do
  let(:user) { users(:one) }
  let(:decorated_user) { user.decorated }

  describe ".available_locales_for_options" do
    it { expect(described_class.available_locales_for_options.pluck(1)).to match_array(User::AVAILABLE_LOCALES) }
  end

  describe ".available_themes_for_options" do
    it { expect(described_class.available_themes_for_options.pluck(1)).to match_array(User::AVAILABLE_THEMES) }
  end

  describe ".available_background_colors_for_options" do
    it { expect(described_class.available_background_colors_for_options.pluck(1)).to match_array(User::AVAILABLE_BAY_BACKGROUND_COLORS) }
  end

  describe ".available_bay_orientations_for_options" do
    it { expect(described_class.available_bay_orientations_for_options.pluck(1)).to match_array(User::AVAILABLE_BAY_ORIENTATIONS) }
  end

  describe ".roles_for_options" do
    it { expect(described_class.roles_for_options.pluck(1)).to match_array(User.roles.pluck(0)) }
  end

  describe "#role_human_name" do
    let(:role) { nil }

    before do
      user.role = role
    end

    context "when no role" do
      it { expect(decorated_user.role_human_name).to eq(User.human_attribute_name("role.none")) }
    end

    context "when role is reader" do
      let(:role) { :reader }

      it { expect(decorated_user.role_human_name).to eq(User.human_attribute_name("role.reader")) }
    end

    context "when role is writer" do
      let(:role) { :writer }

      it { expect(decorated_user.role_human_name).to eq(User.human_attribute_name("role.writer")) }
    end
  end
end
