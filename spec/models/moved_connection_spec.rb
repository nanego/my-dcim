# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MovedConnection, type: :model do
  let(:moved_connection) { MovedConnection.create(color: "bleu", cablename: "cable") }

  describe "associations" do
    it { is_expected.to belong_to(:port_from) }
    it { is_expected.to belong_to(:port_to) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :port_from_id }
  end

  describe "#ports" do
    pending
  end

  describe "#cable_color" do
    it { expect(moved_connection.cable_color).to eq moved_connection.color }
  end

  describe ".per_servers" do
    pending
  end

  describe "#execute_movement" do
    pending
  end

  describe "#cable_color" do
    it { expect(moved_connection.cable_name).to eq moved_connection.cablename }
  end
end
