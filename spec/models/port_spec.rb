# frozen_string_literal: true

require "rails_helper"

RSpec.describe Port do
  # it_behaves_like "changelogable", new_attributes: {  }

  describe "associations" do
    it { is_expected.to belong_to(:attachable) }

    it { is_expected.to have_one(:connection) }
    it { is_expected.to have_one(:cable).through(:connection) }

    it { is_expected.to have_many(:connections).dependent(:destroy) }
    it { is_expected.to have_many(:moved_connection_froms).dependent(:destroy) }
    it { is_expected.to have_many(:moved_connection_tos).dependent(:nullify) }
  end

  describe ".to_txt" do
    pending
  end

  describe ".to_csv" do
    pending
  end

  describe "#frame" do
    subject(:port) { described_class.new(attachable:) }

    context "when attachable is a Card" do
      let(:attachable) { cards(:one) }

      it { expect(port.frame).to eq(attachable.server.frame) }
    end

    context "when attachable is a PowerDistributionUnit::Socket" do
      let(:attachable) { power_distribution_unit_sockets(:one) }

      it { expect(port.frame).to eq(attachable.circuit.record.frame) }
    end
  end

  describe "#network_conf" do
    pending
  end

  describe "#connect_to_port" do
    pending
  end
end
