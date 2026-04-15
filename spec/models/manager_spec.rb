# frozen_string_literal: true

require "rails_helper"

RSpec.describe Manager do
  subject(:manager) { described_class.new(name: "DIS/GIL") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:servers) }
  end

  describe "#to_s" do
    it { expect(manager.to_s).to eq manager.name }
  end
end
