# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnit::CircuitDecorator, type: :decorator do
  describe ".options_for_select" do
    it { expect(described_class.options_for_select(power_distribution_units(:one).circuits)).to contain_exactly(["pdu circuit", 1], ["second circuit per pdu", 3]) }
  end
end
