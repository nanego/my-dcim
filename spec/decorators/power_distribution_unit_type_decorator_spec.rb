# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitTypeDecorator, type: :decorator do
  describe ".manufacturers_options_for_select" do
    it do
      expect(described_class.manufacturers_options_for_select)
        .to contain_exactly(["Fourth", 4], ["Third", 3], ["fortinet", 1], ["juniper", 2])
    end
  end

  describe ".current_type_options_for_select" do
    it do
      expect(described_class.current_type_options_for_select)
        .to contain_exactly(["Trois phases", "three_phase"], ["Une phase", "single_phase"])
    end
  end
end
