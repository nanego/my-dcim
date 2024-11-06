# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Card do
  # it_behaves_like "changelogable", object: -> { described_class.new }, new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to belong_to(:card_type) }
    it { is_expected.to belong_to(:server) }
    it { is_expected.to belong_to(:composant) }
    it { is_expected.to have_many(:ports) }
    it { is_expected.to have_many(:cables).through(:ports) }
  end

  describe "validations" do
    it { is_expected.to validate_numericality_of(:first_position).only_integer.is_in(0..100).allow_nil }
  end

  describe "#to_s" do
    pending
  end

  describe "#first_port_position" do
    pending
  end

  describe "#positions_with_ports" do
    pending
  end

  describe "#create_missing_ports" do
    pending
  end

  describe "#set_twin_card" do
    pending
  end
end
