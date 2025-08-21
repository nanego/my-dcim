# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/gestions" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    context "with managers without associations" do
      it do
        expect do
          delete bulk_gestions_path(ids: [gestions(:three).id, gestions(:two).id])
        end.to change(Gestion, :count).by(-2)
      end

      it do
        delete bulk_gestions_path(ids: [gestions(:three).id, gestions(:two).id])
        expect(response).to redirect_to(gestions_path)
      end
    end

    context "with a manager type with associations" do
      it do
        expect do
          delete bulk_gestions_path(ids: [gestions(:one).id])
        end.not_to change(Gestion, :count)
      end

      it do
        delete bulk_gestions_path(ids: [gestions(:one).id])
        expect(response).to redirect_to(gestions_path)
      end
    end
  end
end
