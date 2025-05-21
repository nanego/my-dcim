# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovesProject do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:move) { described_class.new(name: "A") }

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#to_s" do
    it { expect(move.to_s).to eq("A") }
  end
end
