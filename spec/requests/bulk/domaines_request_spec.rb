# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/domaines" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with domaines without associations" do
      it do
        expect do
          delete bulk_domaines_path(ids: [domaines(:three).id, domaines(:stock).id])
        end.to change(Domaine, :count).by(-2)
      end

      it do
        delete bulk_domaines_path(ids: [domaines(:three).id, domaines(:stock).id])
        expect(response).to redirect_to(domaines_path)
      end
    end

    context "with a domaine type with associations" do
      it do
        expect do
          delete bulk_domaines_path(ids: [domaines(:switch).id])
        end.not_to change(CardType, :count)
      end

      it do
        delete bulk_domaines_path(ids: [domaines(:switch).id])
        expect(response).to redirect_to(domaines_path)
      end
    end
  end
end
