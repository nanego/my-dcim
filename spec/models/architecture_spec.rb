# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Architecture do
  subject(:architecture) { described_class.new(name: "Tour") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:modeles) }
  end

  describe "#to_s" do
    it { expect(architecture.to_s).to eq architecture.name }
  end
end
