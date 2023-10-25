# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PortType, type: :model do
  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  let(:port_type) { PortType.create(name: "ALIM") }

  describe "associations" do
    it { is_expected.to have_many(:card_types) }
  end

  describe "#is_power_input?" do
    it { expect(port_type.is_power_input?).to be true }
  end
end
