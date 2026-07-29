# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitSocketDecorator, type: :decorator do
  describe ".port_types_options_for_select" do
    it { expect(described_class.port_types_options_for_select).to contain_exactly(["ALIM", 4]) }
  end
end
