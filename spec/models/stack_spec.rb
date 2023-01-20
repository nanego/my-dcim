# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stack, type: :model do
  let(:stack) { Stack.create(name: "Rouge") }

  describe "associations" do
    it { is_expected.to have_many(:servers) }
  end

  describe "#to_s" do
    it { expect(stack.to_s).to eq stack.name }
  end
end
