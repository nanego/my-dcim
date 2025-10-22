# frozen_string_literal: true

require "rails_helper"

RSpec.describe FrameDecorator, type: :decorator do
  let(:user) { users(:admin) }

  describe ".options_for_select" do
    it do
      expect(described_class.options_for_select(user))
        .to contain_exactly(["MyFrame1", 1], ["MyFrame2", 2], ["MyFrame3", 3], ["MyFrame4", 4], ["MyFrame5", 5])
    end
  end

  describe ".rooms_options_for_select" do
    it do
      expect(described_class.rooms_options_for_select(user))
        .to contain_exactly(["Site 1 - S1", 1], ["Site 1 - S2", 2], ["Site 1 - S5", 5], ["Site 2 - S3", 3], ["Site 2 - S4", 4], ["Site 3 - S6", 6])
    end
  end

  describe ".islets_options_for_select" do
    it do
      expect(described_class.islets_options_for_select(user))
        .to contain_exactly(["Ilot Islet1 S1", 1], ["Ilot Islet2 S1", 2], ["Ilot Islet3 S1", 3], ["Ilot Islet4 S6", 4], ["Ilot Islet5 S1", 5])
    end
  end

  describe ".bays_options_for_select" do
    it do
      expect(described_class.bays_options_for_select(user))
        .to contain_exactly(["Baie vide", 3], ["Baie vide", 5], ["MyFrame1 / MyFrame2", 1], ["MyFrame3 / MyFrame4", 2], ["MyFrame5", 4])
    end
  end

  describe ".access_control_options_for_select" do
    it do
      expect(described_class.access_control_options_for_select)
        .to contain_exactly(["Badge", "badge"], ["Clé", "key"], ["Clé Locken", "locken_key"])
    end
  end
end
