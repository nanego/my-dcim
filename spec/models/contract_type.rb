# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractType, type: :model do
  subject(:contract_type) { ContractType.new(name: "Dell Pro Support") }

  describe "associations" do
    it { is_expected.to have_many(:maintenance_contracts) }
  end

  describe "#to_s" do
    it { expect(contract_type.to_s).to be contract_type.name }
  end
end
