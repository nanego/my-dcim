# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitDecorator, type: :decorator do
  let(:user) { users(:admin) }

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

  describe ".power_distribution_unit_types_options_for_select" do
    it do
      expect(described_class.power_distribution_unit_types_options_for_select)
        .to contain_exactly(["PDU type name 1", 1], ["PDU type name 2", 2])
    end
  end

  describe ".manufacturers_options_for_select" do
    it do
      expect(described_class.manufacturers_options_for_select)
        .to contain_exactly(["Fourth", 4], ["Third", 3], ["fortinet", 1], ["juniper", 2])
    end
  end

  describe ".side_options_for_select" do
    it do
      expect(described_class.side_options_for_select)
        .to contain_exactly(%w[Droite right], %w[Gauche left])
    end
  end

  describe ".orientation_options_for_select" do
    it do
      expect(described_class.orientation_options_for_select)
        .to contain_exactly(%w[ASC asc], %w[DESC desc])
    end
  end
end
