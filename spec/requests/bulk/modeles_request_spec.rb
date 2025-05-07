# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/modeles" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with modeles without associations" do
      it do
        expect do
          delete bulk_modeles_path(ids: [modeles(:four).id, modeles(:five).id])
        end.to change(Modele, :count).by(-2)
      end

      it do
        delete bulk_modeles_path(ids: [modeles(:four).id, modeles(:five).id])
        expect(response).to redirect_to(modeles_path)
      end
    end

    context "with a modele with associations" do
      it do
        expect do
          delete bulk_modeles_path(ids: [modeles(:one).id])
        end.not_to change(Modele, :count)
      end

      it do
        delete bulk_modeles_path(ids: [modeles(:one).id])
        expect(response).to redirect_to(modeles_path)
      end
    end
  end
end
