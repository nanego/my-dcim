# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnit::Circuit do
  subject(:circuit) { described_class.new(name: "C1", record: power_distribution_units(:one)) }

  it_behaves_like "changelogable", object: -> { circuit }, new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to belong_to(:record) }
    it { is_expected.to have_many(:sockets).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end
end
