# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnit::Socket do
  subject(:socket) do
    described_class.new(name: "S1",
                        circuit: power_distribution_unit_circuits(:one),
                        port_type: port_types(:one))
  end

  describe "associations" do
    it { is_expected.to belong_to(:port_type) }
    it { is_expected.to belong_to(:circuit) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end
end
