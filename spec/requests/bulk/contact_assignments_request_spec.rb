# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/contact_assignments" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with contact assignments without associations" do
      let(:contact_assignments_one) { ContactAssignment.create!(site: sites(:one), contact: contacts(:one), contact_role: contact_roles(:one)) }
      let(:contact_assignments_two) { ContactAssignment.create!(site: sites(:two), contact: contacts(:two), contact_role: contact_roles(:two)) }

      before do
        contact_assignments_one
        contact_assignments_two
      end

      it do
        expect do
          delete bulk_contact_assignments_path(ids: [contact_assignments_one.id, contact_assignments_two.id])
        end.to change(ContactAssignment, :count).by(-2)
      end

      it do
        delete bulk_contact_assignments_path(ids: [contact_assignments_one.id, contact_assignments_two.id])
        expect(response).to redirect_to(contact_assignments_path)
      end
    end
  end
end
