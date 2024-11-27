# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactAssignmentsProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { ContactAssignment.all }
  let(:params) { {} }

  describe "when filtering by contact_ids" do
    let(:contact) { Contact.create!(first_name: "J", last_name: "D") }
    let(:contact_assignment) do
      ContactAssignment.create!(site: sites(:one), contact: contact, contact_role: contact_roles(:one))
    end

    before do
      contact_assignment
      ContactAssignment.create!(site: sites(:two), contact: contacts(:one), contact_role: contact_roles(:one))
    end

    context "with one contact_ids" do
      let(:params) { { contact_ids: contact.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(contact_assignment) }
    end

    context "with many contact_ids" do
      let(:contact_second) { Contact.create!(first_name: "Z", last_name: "Y") }
      let(:contact_assignment_second) do
        ContactAssignment.create!(site: sites(:two), contact: contact_second, contact_role: contact_roles(:two))
      end

      let(:params) { { contact_ids: [contact.id, contact_second.id] } }

      before do
        contact_assignment_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(contact_assignment, contact_assignment_second) }
    end
  end

  describe "when filtering by site_ids" do
    let(:site) { Site.create!(name: "S1") }
    let(:contact_assignment) do
      ContactAssignment.create!(site: site, contact: contacts(:one), contact_role: contact_roles(:one))
    end

    before do
      contact_assignment
      ContactAssignment.create!(site: sites(:two), contact: contacts(:one), contact_role: contact_roles(:one))
    end

    context "with one site_ids" do
      let(:params) { { site_ids: site.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(contact_assignment) }
    end

    context "with many site_ids" do
      let(:site_second) { Site.create!(name: "S2") }
      let(:contact_assignment_second) do
        ContactAssignment.create!(site: site_second, contact: contacts(:two), contact_role: contact_roles(:two))
      end

      let(:params) { { site_ids: [site.id, site_second.id] } }

      before do
        contact_assignment_second
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(contact_assignment, contact_assignment_second) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end
end
