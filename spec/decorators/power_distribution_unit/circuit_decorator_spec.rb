# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnit::CircuitDecorator, type: :decorator do
  describe ".options_for_select" do
    it { expect(described_class.options_for_select(power_distribution_units(:one).circuits)).to contain_exactly(["ALIM", 4]) }
  end
end
