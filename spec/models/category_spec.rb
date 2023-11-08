# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  subject(:category) { Category.new(name: "Pdu") }

  describe "associations" do
    it { is_expected.to have_many(:modeles) }
  end

  describe "#to_s" do
    it { expect(category.to_s).to eq category.name }
  end

  describe "#pdu?" do
    it { expect(category.pdu?).to eq true }
  end
end
