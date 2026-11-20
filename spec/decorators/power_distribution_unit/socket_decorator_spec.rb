# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnit::SocketDecorator, type: :decorator do
  describe ".port_types_options_for_select" do
    it { expect(described_class.port_types_options_for_select).to contain_exactly(["ALIM", 4]) }
  end

  describe ".circuits_options_for_select" do
    let(:socket) { power_distribution_unit_sockets(:one) }

    it { expect(described_class.circuits_options_for_select(socket)).to contain_exactly(["pdu circuit", 1], ["second circuit per pdu", 3]) }
  end
end
