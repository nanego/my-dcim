# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitDecorator, type: :decorator do
  let(:power_distribution_unit) { power_distribution_units(:one) }
  let(:decorated_power_distribution_unit) { power_distribution_unit.decorated }
  let(:user) { users(:admin) }

  describe ".islets_options_for_select" do
    it do
      expect(described_class.islets_options_for_select(user))
        .to contain_exactly(["Ilot Islet1 S1", 1], ["Ilot Islet2 S1", 2], ["Ilot Islet3 S1", 3], ["Ilot Islet4 S6", 4], ["Ilot Islet5 S1", 5])
    end
  end
end
