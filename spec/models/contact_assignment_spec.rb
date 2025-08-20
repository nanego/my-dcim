# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactAssignment do
  subject(:contact_assignment) do
    described_class.new(site: sites(:one), contact: contacts(:one), contact_role: contact_roles(:one))
  end

  it_behaves_like "changelogable", object: lambda {
    described_class.new(site: sites(:one), contact: contacts(:one), contact_role: contact_roles(:one))
  }, new_attributes: { site_id: 2 }

  describe "associations" do
    it { is_expected.to belong_to(:site) }
    it { is_expected.to belong_to(:contact) }
    it { is_expected.to belong_to(:contact_role) }
  end

  describe "#to_s" do
    it { expect(contact_assignment.to_s).to eq("Site 1 - John Doe CFO") }
  end
end
