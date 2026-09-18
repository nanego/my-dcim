# frozen_string_literal: true

require "rails_helper"

RSpec.describe Connection do
  # it_behaves_like "changelogable", new_attributes: {  }

  describe "associations" do
    it { is_expected.to belong_to(:cable) }
    it { is_expected.to belong_to(:port) }

    it { is_expected.to have_one(:card).through(:port).source(:attachable) }
    it { is_expected.to have_one(:server).through(:card) }
    it { is_expected.to have_one(:card_type).through(:card) }

    it { is_expected.to have_one(:socket).through(:port).source(:attachable) }
    it { is_expected.to have_one(:socket_power_distribution_unit).through(:socket) }

    it { is_expected.to have_one(:power_distribution_unit_card).through(:port).source(:attachable) }
    it { is_expected.to have_one(:card_power_distribution_unit).through(:power_distribution_unit_card).source(:record) }
  end

  describe "#power_distribution_unit" do
    subject(:power_distribution_unit) { connection.power_distribution_unit }

    context "with socket" do
      let(:connection) { connections(:seven) }

      it { expect(power_distribution_unit).to eq(power_distribution_units(:one)) }
    end

    context "with card" do
      let(:connection) { connections(:nine) }

      it { expect(power_distribution_unit).to eq(power_distribution_units(:one)) }
    end

    context "with server" do
      let(:connection) { connections(:one) }

      it { expect(power_distribution_unit).to be_nil }
    end
  end

  describe "#paired_connection" do
    pending
  end

  describe "#port_type" do
    subject(:connection) { described_class.new(port:) }

    context "when attachable is a Card" do
      let(:port) { ports(:one) }

      it { expect(connection.port_type).to eq(connection.card_type.port_type) }
    end

    context "when attachable is a PowerDistributionUnit::Socket" do
      let(:port) { ports(:eleven) }

      it { expect(connection.port_type).to eq(connection.socket.port_type) }
    end
  end
end
