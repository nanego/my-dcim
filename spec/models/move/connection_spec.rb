# frozen_string_literal: true

require "rails_helper"

RSpec.describe Move::Connection do
  subject(:move_connection) { move_connections(:one) }

  # it_behaves_like "changelogable", new_attributes: {  }

  describe "validations" do
    it { is_expected.to be_valid }
  end

  describe "associations" do
    it { is_expected.to belong_to(:move) }

    it { is_expected.to belong_to(:port_from).class_name("Port") }
    it { is_expected.to belong_to(:port_to).optional(true).class_name("Port") }
  end

  describe "#ports" do
    context "with port_from and port_to specified" do
      it { expect(move_connection.ports).to eq([ports(:nine), ports(:ten)]) }
    end

    context "without port_from and port_to specified" do
      subject(:move_connection) { described_class.new(move: moves(:one)) }

      it { expect(move_connection.ports).to eq([]) }
    end
  end

  describe "#execute!" do
    let(:port_from) { ports(:nine) }

    it do
      expect { move_connection.execute! }
        .to change(move_connection, :executed_at).from(nil)
        .and change(Cable, :count).by(1)
        .and change(Connection, :count).by(2)
    end

    it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      expect(port_from.vlans).not_to eq(move_connection.vlans)

      move_connection.execute!
      move_connection.reload
      port_from.reload

      expect(port_from.vlans).to eq(move_connection.vlans)
      expect(Cable.last.name).to eq(move_connection.cable_name)
    end

    context "when already executed" do
      subject(:move_connection) { described_class.new(executed_at: Time.zone.now) }

      it { expect(move_connection.execute!).to be_nil }
    end
  end

  describe "#executed?" do
    it { expect(move_connection.executed?).to be(false) }

    context "with executed moved connection" do
      subject(:move_connection) { described_class.new(executed_at: Time.zone.now) }

      it { expect(move_connection.executed?).to be(true) }
    end
  end
end
