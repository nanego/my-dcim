# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnit::Socket do
  subject(:socket) do
    described_class.new(number: 999,
                        circuit: power_distribution_unit_circuits(:one),
                        port_type: port_types(:one))
  end

  it_behaves_like "changelogable", object: -> { socket }, new_attributes: { number: 888 }

  describe "associations" do
    it { is_expected.to belong_to(:circuit) }
    it { is_expected.to belong_to(:port_type) }

    it { is_expected.to have_one(:port).dependent(:destroy) }
    it { is_expected.to have_one(:power_distribution_unit).through(:circuit).source(:record) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:number) }
  end

  describe "#number_unique_within_pdu_or_pdu_type" do
    before { power_distribution_unit_sockets(:one).save }

    context "when number is free" do
      subject(:socket) do
        described_class.new(number: 999, circuit_id: 1, port_type_id: 1)
      end

      it { is_expected.to be_valid }
    end

    context "when number is taken" do
      subject(:socket) do
        described_class.new(number: 1, circuit_id: 1, port_type_id: 1)
      end

      it { is_expected.not_to be_valid }
    end
  end
end
