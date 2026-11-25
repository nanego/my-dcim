# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnit::Socket do
  subject(:socket) do
    described_class.new(position: 999,
                        block: power_distribution_unit_blocks(:one),
                        circuit: power_distribution_unit_circuits(:one),
                        port_type: port_types(:one),
                        name: "some")
  end

  it_behaves_like "changelogable", object: -> { socket }, new_attributes: { name: "new" }

  describe "associations" do
    it { is_expected.to belong_to(:block) }
    it { is_expected.to belong_to(:circuit) }
    it { is_expected.to belong_to(:port_type) }

    it { is_expected.to have_one(:port).dependent(:destroy) }
    it { is_expected.to have_one(:power_distribution_unit).through(:block).source(:record) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:position) }
    it { is_expected.to validate_uniqueness_of(:position).scoped_to(:block_id) }

    describe "name_uniqueness" do
      context "when name is free" do
        subject(:socket) do
          described_class.new(position: 999, name: "uniq name", block_id: 1, circuit_id: 1, port_type_id: 1)
        end

        it { is_expected.to be_valid }
      end

      context "when name is taken" do
        subject(:socket) do
          described_class.new(position: 999, name: "one", block_id: 1, circuit_id: 2, port_type_id: 1)
        end

        it { is_expected.not_to be_valid }
      end
    end
  end

  describe "#create_missing_ports" do
    it do
      expect do
        socket.create_missing_ports
      end.to change(Port, :count).by(1)
    end
  end
end
