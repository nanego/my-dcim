# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/contact_assignments" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with contact assignments without associations" do
      it do
        expect do
          delete bulk_contact_assignments_path(ids: [contact_assignments(:one).id, contact_assignments(:two).id])
        end.to change(ContactAssignment, :count).by(-2)
      end

      it do
        delete bulk_contact_assignments_path(ids: [contact_assignments(:one).id, contact_assignments(:two).id])
        expect(response).to redirect_to(contact_assignments_path)
      end
    end
  end
end
