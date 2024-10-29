# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Islet do
  # it_behaves_like "changelogable", new_attributes: { name: "New name" }

  subject(:islet) { described_class.new(name: "Bleu") }

  describe "associations" do
    it { is_expected.to belong_to(:room) }
    it { is_expected.to have_one(:site).through(:room) }
    it { is_expected.to have_many(:bays) }
    it { is_expected.to have_many(:frames).through(:bays) }
    it { is_expected.to have_many(:servers).through(:frames) }
    it { is_expected.to have_many(:materials).through(:frames) }
  end

  describe "validations" do
    it do
      is_expected.to define_enum_for(:cooling_mode) # rubocop:disable RSpec/ImplicitSubject
        .validating(allowing_nil: true)
        .with_values(%i[hot_containment cold_containment])
    end

    it { is_expected.to define_enum_for(:access_control).with_values(%i[badge key key_loken]) }
  end

  describe "#to_s" do
    pending
  end

  describe "#name_with_room" do
    pending
  end
end
