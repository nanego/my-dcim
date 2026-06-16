# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitType do
  it_behaves_like "changelogable", object: -> { described_class.new(name: "name", manufacturer: manufacturers(:fortinet), current_type: :three_phase) },
                                   new_attributes: { name: "new name" }

  describe "associations" do
    it { is_expected.to belong_to(:manufacturer) }
    it { is_expected.to have_many(:power_distribution_units).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:circuits) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to define_enum_for(:current_type).with_values(%i[three_phase single_phase]) }

    it { is_expected.to allow_value("").for(:documentation_url) }
    it { is_expected.to allow_value("http://exemple.com/doc/1").for(:documentation_url) }
    it { is_expected.not_to allow_value("some invalid url").for(:documentation_url) }
  end

  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:circuits) }
  end
end
