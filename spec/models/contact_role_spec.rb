# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactRole do
  subject(:contact_role) { described_class.new(name: "Manager") }

  it_behaves_like "changelogable", object: -> { described_class.new(name: "Maintainer") },
                                   new_attributes: { name: "Manager" }

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#to_s" do
    it { expect(contact_role.to_s).to eq("Manager") }
  end
end
