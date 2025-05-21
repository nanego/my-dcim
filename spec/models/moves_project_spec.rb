# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovesProject do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:move_project) { described_class.new(name: "A") }

  describe "associations" do
    it { is_expected.to have_many(:steps) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#to_s" do
    it { expect(move_project.to_s).to eq("A") }
  end
end
