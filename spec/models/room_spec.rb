# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room do
  # it_behaves_like "changelogable", new_attributes: { name: "New name" }

  subject(:room) { described_class.new(name: "Petite salle") }

  describe "associations" do
    it { is_expected.to belong_to(:site) }
    it { is_expected.to have_many(:islets) }
    it { is_expected.to have_many(:bays).through(:islets) }
    it { is_expected.to have_many(:frames).through(:bays) }
    it { is_expected.to have_many(:materials).through(:frames) }
  end

  describe "validations" do
    it do
      is_expected.to define_enum_for(:status) # rubocop:disable RSpec/ImplicitSubject
        .validating
        .with_values(%i[active passive planned])
    end
  end

  describe "#to_s" do
    it { expect(room.to_s).to eq room.name }
  end

  describe "#name_with_site" do
    pending
  end

  describe "#should_generate_new_friendly_id?" do
    pending
  end
end
