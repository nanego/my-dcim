# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDecorator, type: :decorator do
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
end
