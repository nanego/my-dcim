# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/contact_roles" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with contact roles without associations" do
      it do
        expect do
          delete bulk_contact_roles_path(ids: [contact_roles(:one).id, contact_roles(:two).id])
        end.to change(ContactRole, :count).by(-2)
      end

      it do
        delete bulk_contact_roles_path(ids: [contact_roles(:one).id, contact_roles(:two).id])
        expect(response).to redirect_to(contact_roles_path)
      end
    end
  end
end
