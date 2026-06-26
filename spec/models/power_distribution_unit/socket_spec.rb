# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnit::Socket do
  subject(:socket) do
    described_class.new(number: 1,
                        circuit: power_distribution_unit_circuits(:one),
                        port_type: port_types(:one))
  end

  it_behaves_like "changelogable", object: -> { socket }, new_attributes: { number: 2 }

  describe "associations" do
    it { is_expected.to belong_to(:circuit) }
    it { is_expected.to belong_to(:port_type) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:number) }
  end
end
