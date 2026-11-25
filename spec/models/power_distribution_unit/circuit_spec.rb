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

    it do
      is_expected.to define_enum_for(:phase) # rubocop:disable RSpec/ImplicitSubject
        .with_values(L1: 1, L2: 2, L3: 3)
        .with_prefix
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_inclusion_of(:max_current).in_array(described_class::ALLOWED_MAX_CURRENT_VALUES).allow_nil }
  end
end
