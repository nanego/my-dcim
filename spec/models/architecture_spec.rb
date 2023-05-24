# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Architecture, type: :model do
  let(:architecture) { Architecture.create(name: "Tour") }

  describe "associations" do
    it { is_expected.to have_many(:modeles) }
  end

  describe "#to_s" do
    it { expect(architecture.to_s).to eq architecture.name }
  end
end
