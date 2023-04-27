# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PortType, type: :model do
  subject(:port_type) { PortType.new(name: "ALIM") }

  describe "associations" do
    it { is_expected.to have_many(:card_types) }
  end

  describe "#is_power_input?" do
    it { expect(port_type.is_power_input?).to be true }
  end
end
