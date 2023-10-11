# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Manufacturer, type: :model do
  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  let(:manufacturer) { Manufacturer.create(name: "BULL") }

  describe "associations" do
    it { is_expected.to have_many(:modeles) }
  end

  describe "#to_s" do
    it { expect(manufacturer.to_s).to eq manufacturer.name }
  end
end
