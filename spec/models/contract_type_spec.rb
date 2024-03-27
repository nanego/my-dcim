# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractType do
  subject(:contract_type) { described_class.new(name: "Dell Pro Support") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:maintenance_contracts) }
  end

  describe "#to_s" do
    it { expect(contract_type.to_s).to be contract_type.name }
  end
end
