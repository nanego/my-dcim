# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/categories" do
  describe "DELETE /destroy" do
    before { sign_in users(:one) }

    context "with categories without associations" do
      it do
        expect do
          delete bulk_categories_path(ids: [categories(:four).id, categories(:five).id])
        end.to change(Category, :count).by(-2)
      end

      it do
        delete bulk_categories_path(ids: [categories(:four).id, categories(:five).id])
        expect(response).to redirect_to(categories_path)
      end
    end

    context "with a frame with associations" do
      it do
        expect do
          delete bulk_categories_path(ids: [categories(:one).id])
        end.not_to change(Category, :count)
      end

      it do
        delete bulk_categories_path(ids: [categories(:one).id])
        expect(response).to redirect_to(categories_path)
      end
    end
  end
end
