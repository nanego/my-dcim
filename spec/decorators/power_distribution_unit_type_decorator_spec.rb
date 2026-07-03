# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitTypeDecorator, type: :decorator do
  let(:pdu_type) { power_distribution_unit_types(:one) }
  let(:decorated_pdu_type) { pdu_type.decorated }

  describe ".options_for_select" do
    it do
      expect(described_class.options_for_select)
        .to contain_exactly(["PDU type name 1", 1], ["PDU type name 2", 2], ["PDU type name 3", 3])
    end
  end

  describe ".manufacturers_options_for_select" do
    it do
      expect(described_class.manufacturers_options_for_select)
        .to contain_exactly(["Fourth", 4], ["Third", 3], ["fortinet", 1], ["juniper", 2])
    end
  end

  describe ".current_type_options_for_select" do
    it do
      expect(described_class.current_type_options_for_select)
        .to contain_exactly(%w[Triphasé three_phase], %w[Monophasé single_phase])
    end
  end

  describe "#name_with_brand" do
    it { expect(decorated_pdu_type.name_with_brand).to eq("fortinet PDU type name 1") }
  end
end
