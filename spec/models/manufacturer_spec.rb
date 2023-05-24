# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Manufacturer, type: :model do
  let(:manufacturer) { Manufacturer.create(name: "BULL") }

  describe "associations" do
    it { is_expected.to have_many(:modeles) }
  end

  describe "#to_s" do
    it { expect(manufacturer.to_s).to eq manufacturer.name }
  end
end
