# frozen_string_literal: true

require "rails_helper"

RSpec.describe Circuit do
  subject(:circuit) { described_class.new(name: "C1", record: power_distribution_units(:one)) }

  describe "associations" do
    it { is_expected.to belong_to(:record) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end
end
