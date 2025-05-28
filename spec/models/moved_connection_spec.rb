# frozen_string_literal: true

require 'rails_helper'

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
    pending
  end

  describe "#cable_color" do
    it { expect(moved_connection.cable_color).to eq moved_connection.color }
  end

  describe "#execute!" do
    pending
  end

  describe "#cable_name" do
    it { expect(moved_connection.cable_name).to eq moved_connection.cablename }
  end
end
