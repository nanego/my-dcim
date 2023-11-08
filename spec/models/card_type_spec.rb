# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CardType, type: :model do
  subject(:card_type) { CardType.new(name: "2RJ") }

  describe "associations" do
    it { is_expected.to belong_to(:port_type) }
    it { is_expected.to have_many(:cards) }
    it { is_expected.to have_many(:servers).through(:cards) }
  end

  describe "#to_s" do
    it { expect(card_type.to_s).to eq card_type.name }
  end
end
