# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/contacts" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    context "with contacts without associations" do
      it do
        expect do
          delete bulk_contacts_path(ids: [contacts(:one).id, contacts(:two).id])
        end.to change(Contact, :count).by(-2)
      end

      it do
        delete bulk_contacts_path(ids: [contacts(:one).id, contacts(:two).id])
        expect(response).to redirect_to(contacts_path)
      end
    end
  end
end
