# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitSocketDecorator, type: :decorator do
  describe ".port_type_options_for_select" do
    it do
      expect(described_class.port_type_options_for_select).to contain_exactly(["ALIM", 4], ["FC", 1], ["Five", 5], ["IPMI", 3], ["RJ", 2], ["Six", 6])
    end
  end
end
