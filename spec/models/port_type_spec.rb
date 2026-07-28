# frozen_string_literal: true

require "rails_helper"

RSpec.describe PortType do
  subject(:port_type) { described_class.new(name: "ALIM") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:card_types).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:sockets).dependent(:restrict_with_error) }
  end

  describe "validations" do
    it { is_expected.to validate_array_inclusion_of(:attachable_to).in(%w[server]) }
  end

  describe "#is_power?" do
    it { expect(port_type.is_power?).to be false }
  end
end
