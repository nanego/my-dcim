# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactAssignmentsProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { ContactAssignment.all }
  let(:params) { {} }

  describe "when filtering by site_id" do
    let(:site) { Site.create!(name: "S1") }
    let(:contact_assignment) do
      ContactAssignment.create!(site: site, contact: contacts(:one), contact_role: contact_roles(:one))
    end

    let(:params) { { site_id: site.id } }

    before do
      contact_assignment
      ContactAssignment.create!(site: sites(:two), contact: contacts(:one), contact_role: contact_roles(:one))
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(contact_assignment) }
  end

  describe "when filtering by contact_id" do
    let(:contact) { Contact.create!(first_name: "J", last_name: "D") }
    let(:contact_assignment) do
      ContactAssignment.create!(site: sites(:one), contact: contact, contact_role: contact_roles(:one))
    end

    let(:params) { { contact_id: contact.id } }

    before do
      contact_assignment
      ContactAssignment.create!(site: sites(:two), contact: contacts(:one), contact_role: contact_roles(:one))
    end

    it { expect(result.size).to eq(1) }
    it { is_expected.to include(contact_assignment) }
  end

  describe "when sorting" do
    pending "TODO"
  end
end
