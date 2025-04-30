# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/card_types" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with card types without associations" do
      it do
        expect do
          delete bulk_card_types_path(ids: [card_types(:three).id, card_types(:five).id])
        end.to change(CardType, :count).by(-2)
      end

      it do
        delete bulk_card_types_path(ids: [card_types(:three).id, card_types(:five).id])
        expect(response).to redirect_to(card_types_path)
      end
    end

    context "with a card type with associations" do
      it do
        expect do
          delete bulk_card_types_path(ids: [card_types(:one).id])
        end.not_to change(CardType, :count)
      end

      it do
        delete bulk_card_types_path(ids: [card_types(:one).id])
        expect(response).to redirect_to(card_types_path)
      end
    end
  end
end
