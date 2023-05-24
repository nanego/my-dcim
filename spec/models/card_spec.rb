# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Card, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:card_type) }
    it { is_expected.to belong_to(:server) }
    it { is_expected.to belong_to(:composant) }
    it { is_expected.to have_many(:ports) }
    it { is_expected.to have_many(:cables).through(:ports) }
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
