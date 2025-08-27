# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovedConnection do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:moved_connection) { described_class.new(color: "bleu", cablename: "cable") }

  describe "associations" do
    it { is_expected.to belong_to(:port_from) }
    it { is_expected.to belong_to(:port_to).optional(true) }
  end

  describe "validations" do
    xit { is_expected.to be_valid }
  end

  describe ".per_servers" do
    pending
  end

  describe "#ports" do
    it { expect(moved_connection.ports).to eq([]) }

    context "with port_from and port_to specified" do
      subject(:moved_connection) { described_class.new(port_from: ports(:one), port_to: ports(:two)) }

      it { expect(moved_connection.ports).to eq([ports(:one), ports(:two)]) }
    end
  end

  describe "#cable_color" do
    it { expect(moved_connection.cable_color).to eq moved_connection.color }
  end

  describe "#execute!" do
    subject(:moved_connection) { described_class.create(port_from:, port_to:, cablename: "A") }

    let(:port_from) { ports(:six) }
    let(:port_to) { ports(:seven) }

    it do
      expect { moved_connection.execute! }
        .to change(moved_connection, :executed_at).from(nil)
        .and change(Cable, :count).by(1)
        .and change(Connection, :count).by(2)
    end

    it :aggregate_failures do
      expect(port_from.cablename).not_to eq(moved_connection.cablename)

      moved_connection.execute!
      moved_connection.reload
      port_from.reload

      expect(port_from.cable_name).to eq(moved_connection.cablename)
    end

    context "when already executed" do
      subject(:moved_connection) { described_class.new(executed_at: Time.zone.now) }

      it { expect(moved_connection.execute!).to be_nil }
    end
  end

  describe "#executed?" do
    it { expect(moved_connection.executed?).to be(false) }

    context "with executed moved connection" do
      subject(:moved_connection) { described_class.new(executed_at: Time.zone.now) }

      it { expect(moved_connection.executed?).to be(true) }
    end
  end

  describe "#cable_name" do
    it { expect(moved_connection.cable_name).to eq moved_connection.cablename }
  end
end
